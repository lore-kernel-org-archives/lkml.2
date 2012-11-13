Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2KMWpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:45:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46785 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2KMWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:45:44 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v3 2/2] i2c: i2c-ocores: Add support for the GRLIB port of the controller and custom getreg and setreg functions
References: <1352834727-16368-1-git-send-email-andreas@gaisler.com>
	<1352834727-16368-3-git-send-email-andreas@gaisler.com>
Date: Tue, 13 Nov 2012 23:45:39 +0100
In-Reply-To: <1352834727-16368-3-git-send-email-andreas@gaisler.com> (Andreas
	Larsson's message of "Tue, 13 Nov 2012 20:25:27 +0100")
Message-ID: <87sj8d86lo.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Larsson <andreas@gaisler.com> writes:

Hi,

 Andreas> The registers in the GRLIB port of the controller are 32-bit
 Andreas> and in big endian byte order. The PRELOW and PREHIGH registers
 Andreas> are merged into one register. The subsequent registers have
 Andreas> their offset decreased accordingly. Hence the register access
 Andreas> needs to be handled in a non-standard manner using custom
 Andreas> getreg and setreg functions.

 Andreas> @@ -257,6 +300,14 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 
 Andreas>  	of_property_read_u32(pdev->dev.of_node, "reg-io-width",
 Andreas>  				&i2c->reg_io_width);
 Andreas> +
 Andreas> +	if (of_device_is_compatible(pdev->dev.of_node,
 Andreas> +				    "aeroflexgaisler,i2cmst")) {
 Andreas> +		dev_dbg(&pdev->dev, "GRLIB variant of i2c-ocores\n");
 Andreas> +		i2c->setreg = oc_setreg_grlib;
 Andreas> +		i2c->getreg = oc_getreg_grlib;
 Andreas> +	}
 Andreas> +

Please also update the bindings documentation under
Documentation/devicetree/bindings/i2c.

With this core you need to add both aeroflexgaisler,i2cmst and
opencores,i2c-ocores to the compatible property, but the grlib variant
is NOT compatible with i2c-ocores, so that's not really nice.

Adding a type define (TYPE_OCORES / TYPE_GRLIB) and a 2nd of_device_id
entry with .data = TYPE_GRLIB, and then using that in the probe routine
would be nicer. Have a look at i2c-at91.c for an example of a driver
doing something like that.

-- 
Bye, Peter Korsgaard
