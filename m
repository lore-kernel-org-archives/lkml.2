Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2GETJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:09:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35397 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2GETJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:09:33 -0400
Message-ID: <4FF5E66A.6010108@wwwdotorg.org>
Date: Thu, 05 Jul 2012 13:09:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, lrg@ti.com, swarren@nvidia.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] regulator: tps65910: add support for input supply
References: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 08:03 AM, Laxman Dewangan wrote:
> There is multiple voltage input pins on device which
> takes the voltage input for different voltage regulator.
> Support to configure the voltage input supplied by
> different regulator for each regulators.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

A couple nit-picky comments below:

> diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt

> +- vin-xxx-supply: Input voltage supply regulator.

It'd be nice to name these simply xxx-supply; the "vin-" seems redundant.

> +  Missing of these properties will be assume as there is no parent regulator
> +  for that input pins and always powered on.
> +  The valid input supply properties are:
> +  tps65910:
> +	vin-vcc7-supply: VRTC input.
> +	vin-vccio-supply: VIO input.
> +	vin-vcc1-supply: VDD1 input.
> +	vin-vcc2-supply: VDD2 input.
> +	vin-vcc6-supply: VDIG1 and VDIG2 input.
> +	vin-vcc5-supply: VPLL and VDAC input.
> +	vin-vcc4-supply: VAUX1 and VAUX2 input.
> +	vin-vcc3-supply: VAUX33 and VMMC input.
> +  tps65911:
> +	vin-vcc7-supply: VRTC input.
> +	vin-vcc1-supply: VDD1 input.
> +	vin-vcc2-supply: VDD2 input.
> +	vin-vccio-supply: VIO input.
> +	vin-vcc6-supply: LDO1 and LDO2 input.
> +	vin-vcc5-supply: LDO3 and LDO4 input.
> +	vin-vcc4-supply: LDO5 input.
> +	vin-vcc3-supply: LDO6, LDO7 and LDO8 input.

It'd be nice to sort these lists of names so they appear in some
discernible order.
