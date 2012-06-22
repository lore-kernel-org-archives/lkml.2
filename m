Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2FVTJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:09:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57955 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2FVTJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
References: <1340387371-32292-1-git-send-email-mjg59@srcf.ucam.org>
Date: Fri, 22 Jun 2012 21:09:22 +0200
Message-ID: <CAFLxGvxL2jzCNsT=H3i3P2RJSBMN5ZVP=fZuxO01UJxLVyZAsQ@mail.gmail.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Alex Lyashkov <umka@cloudlinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 7:49 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Cloudlinux have a product called lve that includes a kernel module. This
> was previously GPLed but is now under a proprietary license, but the
> module continues to declare MODULE_LICENSE("GPL") and makes use of some
> EXPORT_SYMBOL_GPL symbols. Forcibly taint it in order to avoid this.
>
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Alex Lyashkov <umka@cloudlinux.com>
> ---
>  kernel/module.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 4edbd9c..9ad9ee9 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2730,6 +2730,10 @@ static int check_module_license_and_versions(struct module *mod)
>        if (strcmp(mod->name, "driverloader") == 0)
>                add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
>
> +       /* lve claims to be GPL but upstream won't provide source */
> +       if (strcmp(mod->name, "lve") == 0)
> +               add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
> +

If this kernel module is really lying to us the kernel should simply
refuse to load it and
call a lawyer.

-- 
Thanks,
//richard
