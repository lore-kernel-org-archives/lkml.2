Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2K3Jyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:54:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55816 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2K3Jyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:54:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH -next] of: export "allnodes" to fixx w1-gpio.c modular build
To: Randy Dunlap <rdunlap@infradead.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Ville Syrjala <syrjala@sci.fi>
In-Reply-To: <50B7F30C.1060105@infradead.org>
References: <20121129174057.99da02b15426c76054d05592@canb.auug.org.au> <50B7F30C.1060105@infradead.org>
Date: Fri, 30 Nov 2012 09:54:33 +0000
Message-Id: <20121130095433.9F4743E070C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 15:43:08 -0800, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build when CONFIG_W1_MASTER_GPIO=m by exporting "allnodes".
> 
> ERROR: "allnodes" [drivers/w1/masters/w1-gpio.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Ville Syrjala <syrjala@sci.fi>
> ---
>  drivers/of/base.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20121129.orig/drivers/of/base.c
> +++ linux-next-20121129/drivers/of/base.c
> @@ -46,6 +46,7 @@ struct alias_prop {
>  static LIST_HEAD(aliases_lookup);
>  
>  struct device_node *allnodes;
> +EXPORT_SYMBOL(allnodes);

Makes sense, but I don't like exporting such a generic name. I'm picking
up the patch but renaming s/allnodes/of_allnodes/ in the process.

g.

