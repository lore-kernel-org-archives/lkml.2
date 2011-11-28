Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab1K1WZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:25:50 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52940 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1WZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:25:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Young <dyoung@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20111125081959.GA2505@darkstar.nay.redhat.com>
Date: Mon, 28 Nov 2011 14:27:02 -0800
In-Reply-To: <20111125081959.GA2505@darkstar.nay.redhat.com> (Dave Young's
	message of "Fri, 25 Nov 2011 16:19:59 +0800")
Message-ID: <m1aa7fq3wp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18BtvNn0/YVzbkI2ILrNqmurqVvol8CuXc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Young <dyoung@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] kexec: do not call kmsg_dump in crashdump
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young <dyoung@redhat.com> writes:

> mtd/ram oops dumper will make more functions envolved. In case crash kexec, 
> we should avoid kmsg dumper to ensure crashdump success.
>
> kill kmsg_dump callback while crash dumping 

Agreed.

There is a similar?  Or possibly the same patch already queued in
Andrews tree.

Eric

>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  kernel/kexec.c |    2 --
>  1 file changed, 2 deletions(-)
>
> --- linux-2.6.orig/kernel/kexec.c	2011-11-18 16:34:18.000000000 +0800
> +++ linux-2.6/kernel/kexec.c	2011-11-24 16:05:08.138660500 +0800
> @@ -1094,8 +1094,6 @@ void crash_kexec(struct pt_regs *regs)
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
>  
> -			kmsg_dump(KMSG_DUMP_KEXEC);
> -
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
