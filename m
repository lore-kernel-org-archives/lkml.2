Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020Ab1GOHDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 03:03:45 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:38901 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836Ab1GOHDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 03:03:44 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mcp23s08: add i2c support
References: <1310673568-30577-1-git-send-email-jacmet@sunsite.dk>
	<1310673568-30577-4-git-send-email-jacmet@sunsite.dk>
	<20110715025355.GX2927@ponder.secretlab.ca>
Date: Fri, 15 Jul 2011 09:03:29 +0200
In-Reply-To: <20110715025355.GX2927@ponder.secretlab.ca> (Grant Likely's
	message of "Thu, 14 Jul 2011 20:53:55 -0600")
Message-ID: <8762n4auv2.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

 Grant> On Thu, Jul 14, 2011 at 09:59:28PM +0200, Peter Korsgaard wrote:
 >> Add i2c bindings for the mcp230xx devices. This is quite a lot simpler
 >> than the spi ones as there's no funky sub addressing done (one struct
 >> i2c_client per struct gpio_chip).
 >> 
 >> The mcp23s08_platform_data structure is reused for i2c, even though
 >> only a single mcp23s08_chip_info structure is needed.
 >> 
 >> To make the platform data bus independent, the setup/teardown prototypes
 >> are slightly changed, so the bus specific struct (spi_device / i2c_client)
 >> is passed as a void pointer instead.
 >> 
 >> There's no in-tree users of these callbacks.

 Grant> Why don't we just remove them then?  The notifier mechanism is more
 Grant> generic anyway.

Ok, will do.

 Grant> [...]
 >> @@ -537,9 +705,13 @@ static int __init mcp23s08_init(void)
 >> return ret;
 >> #endif /* CONFIG_SPI_MASTER */
 >> 
 >> +#ifdef CONFIG_I2C
 >> +	ret = i2c_add_driver(&mcp230xx_driver);
 >> +#endif /* CONFIG_I2C */
 >> +

 Grant> Need to unwind on failure to register, or put the i2c driver into a
 Grant> separate module so that each module gets it's own init/exit hooks.

Ok, will unwind.

Thanks for the quick review, will send an updated patch series shortly.

-- 
Bye, Peter Korsgaard
