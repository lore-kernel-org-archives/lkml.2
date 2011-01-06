Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab1AFIrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:47:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33820 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1AFIrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:47:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
References: <1294302325-22593-1-git-send-email-amwang@redhat.com>
Date: Thu, 06 Jan 2011 00:47:00 -0800
In-Reply-To: <1294302325-22593-1-git-send-email-amwang@redhat.com> (Amerigo
	Wang's message of "Thu, 6 Jan 2011 16:25:25 +0800")
Message-ID: <m1bp3uifln.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Uc3CkurFkqYcJjFqpkm58wkXhUAZ10rw=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch] kexec_load: check CAP_SYS_MODULE
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> Eric pointed out that kexec_load() actually allows you to
> run any code you want in ring0, this is more like CAP_SYS_MODULE.

Let me get this straight you want to make the permission checks
less stringent by allowing either CAP_SYS_MODULE or CAP_SYS_BOOT?

CAP_SYS_BOOT is the correct capability.  Sure you can run any
code but only after rebooting.  I don't see how this differs
from any other reboot scenario.

Eric


> Reported-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
>
> ---
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index b55045b..c30d613 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -945,7 +945,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  	int result;
>  
>  	/* We only trust the superuser with rebooting the system. */
> -	if (!capable(CAP_SYS_BOOT))
> +	if (!capable(CAP_SYS_BOOT) || !capable(CAP_SYS_MODULE))
>  		return -EPERM;
>  
>  	/*
