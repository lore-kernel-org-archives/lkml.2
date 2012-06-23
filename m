Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2FWA2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 20:28:52 -0400
Received: from ozlabs.org ([203.10.76.45]:50232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab2FWA2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 20:28:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alex Lyashkov <umka@cloudlinux.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
In-Reply-To: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
References: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 23 Jun 2012 09:30:52 +0930
Message-ID: <87zk7usxqj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 13:49:31 -0400, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Cloudlinux have a product called lve that includes a kernel module. This
> was previously GPLed but is now under a proprietary license, but the
> module continues to declare MODULE_LICENSE("GPL") and makes use of some
> EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alex Lyashkov <umka@cloudlinux.com>
> ---
>  kernel/module.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 4edbd9c..9ad9ee9 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2730,6 +2730,10 @@ static int check_module_license_and_versions(struct module *mod)
>  	if (strcmp(mod->name, "driverloader") == 0)
>  		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
>  
> +	/* lve claims to be GPL but upstream won't provide source */
> +	if (strcmp(mod->name, "lve") == 0)
> +		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
> +
>  #ifdef CONFIG_MODVERSIONS
>  	if ((mod->num_syms && !mod->crcs)
>  	    || (mod->num_gpl_syms && !mod->gpl_crcs)

Applied, and CC'd -stable.

Thanks,
Rusty.
