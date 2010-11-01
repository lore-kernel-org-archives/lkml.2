Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0KATkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:40:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37407 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0KATkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:40:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Olsa <jolsa@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
References: <1288636466-9775-1-git-send-email-jolsa@redhat.com>
Date: Mon, 01 Nov 2010 12:40:41 -0700
In-Reply-To: <1288636466-9775-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 1 Nov 2010 19:34:26 +0100")
Message-ID: <m1zktszvba.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jiri Olsa <jolsa@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] tty: prevent SAK to kill init process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> hi,
>
> hitting "Secure Attention Key" on console that's openned
> by init process, causing panic due to an attempt to kill
> the init process.
>
> Fixing this by skipping the init process in the loop.

This sounds like proper behavior.  The goal of SAK is the guarantee that
no one else has the tty one, and this violates that goal.  Which version
init opens a controlling tty?  I expect it is time to deliver SIGCLUE
to it.

Eric
