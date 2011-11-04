Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab1KDTz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 15:55:27 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:56654 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1KDTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 15:55:26 -0400
Subject: Re: [PATCH] Driver for GE PIO2 VME Card
From: Paul Bolle <pebolle@tiscali.nl>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, Grant Likely <grant.likely@secretlab.ca>,
        devel@driverdev.osuosl.org, manohar.vanga@cern.ch, cota@braap.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111104173126.30940.28135.stgit@ES-BJ21R4J>
References: <20111104173126.30940.28135.stgit@ES-BJ21R4J>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 20:55:14 +0100
Message-ID: <1320436514.14409.309.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few random remarks follow. Ie, things that came up while quickly
scanning this.

On Fri, 2011-11-04 at 17:33 +0000, Martyn Welch wrote:
> diff --git a/drivers/staging/vme/devices/Kconfig b/drivers/staging/vme/devices/Kconfig
> index ca5ba89..99f5414 100644
> --- a/drivers/staging/vme/devices/Kconfig
> +++ b/drivers/staging/vme/devices/Kconfig
> @@ -6,3 +6,13 @@ config VME_USER
>  	  If you say Y here you want to be able to access a limited number of
>  	  VME windows in a manner at least semi-compatible with the interface
>  	  provided with the original driver at http://vmelinux.org/.

Blank line here.

> +config VME_PIO2
> +	tristate "GE PIO2 VME"
> +	help
> +	  If you say Y here you have a GE PIO2. The PIO2 is a 6U VME Card,

Maybe something like: "Say Y here if you have a GE PIO2."?

> +	  implementing 32 solid-state relay switched IO lines, in 4 groups of 8.
> +	  The IO lines are provided as input, output or both as a build time
> +	  option.

What option would that be?

> +	  Otherwise it is safe to say N here.
> +

A lot of modules have the "if you say M here the module will be called"
boilerplate here (which actually doesn't match the line I just made up).

> +/* These are required for each board */
> +MODULE_PARM_DESC(bus, "Enumeration of VMEbus to which the board is connected");
> +module_param_array(bus, int, &bus_num, 0);
> +
> +MODULE_PARM_DESC(base, "Base VME address for PIO2 Registers");
> +module_param_array(base, long, &base_num, 0);
> +
> +MODULE_PARM_DESC(vector, "VME IRQ Vector (Lower 4 bits masked)");
> +module_param_array(vector, int, &vector_num, 0);
> +
> +MODULE_PARM_DESC(level, "VME IRQ Level");
> +module_param_array(level, int, &level_num, 0);
> +
> +MODULE_PARM_DESC(variant, "Last 4 characters of PIO2 board variant");
> +module_param_array(variant, charp, &variant_num, 0);
> +
> +/* This is for debugging */
> +MODULE_PARM_DESC(loopback, "Enable loopback mode on all cards");
> +module_param(loopback, bool, 0);

All module parameters have a sysfs visibility (or permission) of zero.
Why is that? (This might very well be a naive question. But I often
wonder why a certain parameter's permission isn't at least 400, just to
allow a quick check of that parameter.) Are arrays tricky in sysfs?

I can't remember ever having seen guidelines for this. It's possible
they exist and my question is answered after reading those.


Paul Bolle

