Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1LAKPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:15:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1LAKPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:15:24 -0500
From: Thomas Renninger <trenn@suse.de>
To: jim.cromie@gmail.com
Subject: Re: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.ddebug instead of pnp.debug
Date: Thu, 1 Dec 2011 12:15:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <1322683014-13285-20-git-send-email-jim.cromie@gmail.com>
In-Reply-To: <1322683014-13285-20-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011215.21146.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011 20:56:48 jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> resubmit of https://lkml.org/lkml/2010/9/15/398
> 
> This allows usage of generic pnp.ddebug debug parameter instead of
> pnp.debug PNP specific parameter.
It depends on what you compile in which pnp debug parameter one has to use
and both are doing more or less the same?

We could add two pnp parameters in !defined(CONFIG_DYNAMIC_DEBUG) case:
  - deprecate pnp.debug by a message:
    "pnp.debug deprecated, use pnp.ddebug" instead
  - pnp.ddebug doing what pnp.debug is doing currently
The only misleading would be that pnp.ddebug has nothing to do with
dynamic debug if not compiled in, but user would have one parameter
to rely on.

In Documentation/kernel-parameters:
        pnp.debug       [PNP]
                        Enable PNP debug messages.  This depends on the
                        CONFIG_PNP_DEBUG_MESSAGES option.

Would be wrong in defined(CONFIG_DYNAMIC_DEBUG) case with your patch,
but would always work with:
        pnp.ddebug
with my above suggestions.

It's not a big deal and not a perfect solution, just looks a bit confusing
to have 2 different parameters for the same thing.

Bjorn should have a look and acknowledge or sign the pnp parts off.

    Thomas

> I wonder whether CONFIG_PNP_DEBUG_MESSAGES can vanish totally with
> this or at some time. Only advantage having it is: If you are
> restricted and your kernel must not exceed X bytes, you cannot compile
> in PNP debug messages only, but you have to compile in all debug
> messages.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> CC: Thomas Renninger <trenn@suse.de>
> ---
>  drivers/pnp/base.h |    8 ++++++--
>  drivers/pnp/core.c |   13 +++++++++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 

...

> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +static int __init pnp_debug_setup(char *__unused)
> +{
> +	printk(KERN_INFO "DYNAMIC_DEBUG enabled use pnp.ddebug instead of "
> +		"pnp.debug boot param\n");
> +	return 1;
> +}
> +__setup("pnp.debug", pnp_debug_setup);

> +
> +#else
> +
>  #if defined(CONFIG_PNP_DEBUG_MESSAGES)
>  module_param_named(debug, pnp_debug, int, 0644);
>  #endif
> +
> +#endif
> -- 
> 1.7.7.3
> 
> 

