Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2KZQmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:42:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38967 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2KZQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: When constructing the bus id consider assigned-addresses as well
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121121210240.GC15285@obsidianresearch.com>
References: <20121121210240.GC15285@obsidianresearch.com>
Date: Mon, 26 Nov 2012 14:03:16 +0000
Message-Id: <20121126140316.99FE23E194B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 14:02:40 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> 'assigned-addresses' is used for certain PCI device type nodes in
> lieu of 'reg',  since this is enforced by of/address.c, have
> of_device_make_bus_id look there as well.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

If it is a PCI device, then of_device_make_bus_id() shouldn't come into
play. PCI devices already have their own naming scheme. Only
platform_bus device creation uses of_device_make_bus_id(). What am I
missing?

g.

> ---
>  drivers/of/platform.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> of_can_translate_address and of_translate_address already support
> using assigned-addresses.
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index b80891b..4f0f701 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -105,6 +105,8 @@ void of_device_make_bus_id(struct device *dev)
>  	 * For MMIO, get the physical address
>  	 */
>  	reg = of_get_property(node, "reg", NULL);
> +	if (!reg)
> +		reg = of_get_property(node, "assigned-addresses", NULL);
>  	if (reg) {
>  		if (of_can_translate_address(node)) {
>  			addr = of_translate_address(node, reg);
> -- 
> 1.7.5.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
