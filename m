Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab2JQOLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:11:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59609 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756988Ab2JQOLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:11:36 -0400
Message-ID: <1350483095.3072.35.camel@joe-AO722>
Subject: Re: [PATCH 5/5] x86, MCA: Finish mca_config conversion
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 17 Oct 2012 07:11:35 -0700
In-Reply-To: <1350472435-29307-6-git-send-email-bp@amd64.org>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
	 <1350472435-29307-6-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 13:13 +0200, Borislav Petkov wrote:
> mce_ser, mce_bios_cmci_threshold and mce_disabled are the last three
> bools which need conversion. Move them to the mca_config struct and
> adjust usage sites accordingly.
[]
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
[]
> @@ -1009,6 +1004,7 @@ static void mce_clear_info(struct mce_info *mi)
>   */
>  void do_machine_check(struct pt_regs *regs, long error_code)
>  {
> +	struct mca_config *cfg = &mca_cfg;

trivia:

Why use cfg?
This indirection and the cfg-> uses just seem obfuscating.
Isn't mca_cfg. used everywhere else?
No line wrapping is saved by indirecting.

> @@ -1036,7 +1032,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  
>  	this_cpu_inc(mce_exception_count);
>  
> -	if (!mca_cfg.banks)
> +	if (!cfg->banks)



