Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2K0VZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:25:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35296 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2K0VZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:25:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Petr Tesarik <ptesarik@suse.cz>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <3774326.lMtTTFYZT3@azariah.suse.cz>
Date: Tue, 27 Nov 2012 15:25:35 -0600
In-Reply-To: <3774326.lMtTTFYZT3@azariah.suse.cz> (Petr Tesarik's message of
	"Tue, 27 Nov 2012 15:13:32 +0100")
Message-ID: <87ehjeivqo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1880Pgms8tFdmPUdGyq6lwjgG4nmyFaM7k=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Petr Tesarik <ptesarik@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: Save PG_compound or PG_head value in VMCOREINFO
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik <ptesarik@suse.cz> writes:

> To allow filtering of huge pages, makedumpfile must be able to identify
> them in the dump. This can be done by checking for the appropriate
> page flag, so communicate its value to makedumpfile through the VMCOREINFO 
> interface.

I don't have any siginificant problems with exporting this information.
However that #ifddef looks nasty and confusing.

Does that #ifdef exist in the huge page code as well?

Can we always export both?  Can we only export one?

What is the purpose of the #ifdef?

As it stands that looks like code that will figure out how to bitrot
if we just leave it sitting there.

> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
>
> ---
>  kernel/kexec.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1511,6 +1511,11 @@ static int __init crash_save_vmcoreinfo_
>  	VMCOREINFO_NUMBER(NR_FREE_PAGES);
>  	VMCOREINFO_NUMBER(PG_lru);
>  	VMCOREINFO_NUMBER(PG_private);
> +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> +	VMCOREINFO_NUMBER(PG_head);
> +#else
> +	VMCOREINFO_NUMBER(PG_compound);
> +#endif
>  	VMCOREINFO_NUMBER(PG_swapcache);
>  
>  	arch_crash_save_vmcoreinfo();
