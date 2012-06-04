Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2FDRMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:12:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58995 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab2FDRMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:12:07 -0400
Date: Mon, 4 Jun 2012 19:12:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120604171202.GA8533@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20120523100138.GA13506@x1.osrc.amd.com>
 <4FBDCE4A.7050900@intel.com>
 <20120524061145.GA18284@liondog.tnic>
 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
 <4FBF3295.7090608@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
 <1338165058.14538.209.camel@ymzhang.sh.intel.com>
 <4FC2E8CF.2040109@intel.com>
 <4FC2E944.6060903@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC2E944.6060903@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 10:56:04AM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> Disable printk recursion to make sure MCE logs printed out.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2afcbd2..365c35d 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1015,6 +1015,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
>  	char *msg = "Unknown";
>  
> +	printk_recursion_check_disable();
>  	atomic_inc(&mce_entry);
>  
>  	this_cpu_inc(mce_exception_count);
> @@ -1144,6 +1145,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>  out:
>  	atomic_dec(&mce_entry);
> +	printk_recursion_check_enable();
>  	sync_core();

This is still adding the recursion check things in do_machine_check
instead of in print_mce.

Also, this commit message above needs more explanation why we want to
disable the recursion check on an MCE, maybe an example...

Thanks.

-- 
Regards/Gruss,
Boris.
