Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2FWRpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 13:45:11 -0400
Received: from mail-pb0-f56.google.com ([209.85.160.56]:43037 "EHLO
	mail-pb0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2FWRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 13:45:09 -0400
X-Greylist: delayed 8766 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 13:45:09 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Sat, 23 Jun 2012 08:07:12 -0700 (PDT)
In-Reply-To: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=173.61.128.124;
 posting-account=Z8DeKgoAAADzzz7td48SCL1roPWBmWKh
NNTP-Posting-Host: 173.61.128.124
References: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 173.61.128.124
MIME-Version: 1.0
Message-ID: <b770341d-e1e3-4d57-b283-3d8ff92b0d36@googlegroups.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
From: iseletsk@cloudlinux.com
To: fa.linux.kernel@googlegroups.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Everyone,

I am very sorry about this situation. It was my oversight. We planned to close source the module, and we will do it later on. Yet, it looks like one of our developers missed the point -- and did things incorrectly.

Please, give us two-three weeks to straighten things out. By the end of three weeks I plan to have source RPMs with the GPLed version of the modules available in our source repositories.

Later on we will have new module that is not GPL released.

Once again -- I am sorry about the incident. We haven't planned to deceive anyone. This was more of an internal miscommunication then anything else.


I appreciate your understanding,
Igor Seletskiy
CEO of CloudLinux

On Friday, June 22, 2012 1:50:24 PM UTC-4, Matthew Garrett wrote:
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
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

