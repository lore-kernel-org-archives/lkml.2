Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2L2K7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 05:59:07 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:57940 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751590Ab2L2K7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 05:59:04 -0500
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Dec 2012 05:59:04 EST
Date: Sat, 29 Dec 2012 11:20:17 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 0/6 v12] gpio: Add block GPIO
Message-ID: <20121229102017.GA7360@game.jcrosoft.org>
References: <1356281376-25853-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356281376-25853-1-git-send-email-stigge@antcom.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14140739881297357661
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpegrnhhttghomhdruggvnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrudelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpegrnhhttghomhdruggvnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:49 Sun 23 Dec     , Roland Stigge wrote:
> This set of patches adds:
> 
> * Block GPIO API to gpiolib
> * Sysfs support for GPIO API, to provide userland access
> * Device interface for userland access (alternative to sysfs)
> * Devicetree support to instantiate GPIO blocks via DT
> * Example implementations in several gpio drivers since they need
>   special accessor functions for block wise GPIO access (only for some
>   selected drivers since the feature is optional and not suitable for
>   all GPIO hardware)
> * Fix for race condition in gpiolib on device creation
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Tested by: Wolfgang Grandegger <wg@grandegger.com>
> --
> 
> Testing branch available at: git://git.antcom.de/linux-2.6.git blockgpio
> 
> Changes since v11:
> * Removed support for at91, since this one is currently in the migration
>   process to pinctrl implementation
already done for 3.8

in Linus tree

Best Regards,
J.
> * Fixed mask setting via sysfs
> * Device interface: declare gpio_block_fop_poll() static
> 
> Changes since v10:
> * gpioblock-of.c: Catch <1 specified GPIOs
> * gpioblock-of.c: Fixed memory leak in probe()'s error path
> * gpioblock-of.c: Fixed block node's refcount via of_node_put()
> * Added driver support for samsung, mm-lantiq and sa1100
> * Added driver support for at91 (by Wolfgang Grandegger)
> * Added pinctrl driver support for pinctl-nomadik
> 
> Changed since v9:
> * Changed IRQ flags for device interface's poll() from IRQF_TRIGGER_FALLING
>   to IRQF_SHARED
> * Use block name on gpio_request
> * Added spinlock for ISR manipulated data (dev interface / poll())
> 
> Changed since v8:
> * Added poll() function to dev interface for IRQ handling
> * Fixed gpio_block_register() in case of missing CONFIG_GPIO_SYSFS
> * Fixed mask handling in sysfs interface
> * Fixed get_user/put_user pointer (cast)
> 
> Changes since v7:
> * Fixed error in API documentation (name arg missing in prototype)
> * Fixed compile error if sysfs is missing: Moved gpio_block_is_output()
>   out of sysfs-ifdef
> * Added error handling to gpio_block_register()
> * Added mask attribute to sysfs (although dev interface exists now)
> 
> Changes since v6:
> * Changed realloc to list handling
> * Added mask to kernel API
> * Added device interface as userspace API
> * Changed sizeof() to BITS_PER_LONG
> * Fixed multiline comment style
> * Documented direction setting by the user
> * Documented order of handled chips in case of multiple chips in one block
> 
> Changes since v5:
> * Documented sysfs: elaborated on "exported" and "values" attributes
> * Documented sysfs: gpiochip is a separate class now
> * Aggregated driver support patches for block gpio into one single patch
> * Added gpio block driver support for twl6040 and pch
> 
> Changes since v4:
> * Documented word width
> * Bugfix: export/unexport on register/unregister
> * Using default dev_attrs for gpio_block_class
> * Fix gpiolib: race condition on device creation
> * Added driver support for ucb14500, vt8500, xilinx
> 
> Changes since v3:
> * Added driver support for pca953x, em, pl061, max732x, pcf857x
> * Coding style improvements
> * Fixed krealloc memory leak in error case
> * sysfs: values in hex
> * Register blocks in a list
> * Narrowing lock scope
> * Use S_IWUSR and S_IRUGO instead of direct octal values
> * Use for_each_set_bit()
> * Change from unsigned to unsigned long for masks and values
> 
> Changes since v2:
> * Added sysfs support
> * Added devicetree support
> * Added support for lpc32xx, generic
> * Added functions for GPIO block registration
> * Added more error checking
> * Bit remapping bugfix
> 
> Changes since v1:
> * API change to 32/64 bit word, bit masks
> 
> Thanks to Ryan Mallon, Linus Walleij, Stijn Devriendt, Jean-Christophe
> Plagniol-Villard, Mark Brown, Greg Kroah-Hartman, Grant Likely, Stefan
> Roese, Wolfgang Grandegger, Tobias Rutz, Fengguang Wu and Mark Rutland
> for reviewing and testing!
> 
> Roland Stigge (6):
>  gpio: Add a block GPIO API to gpiolib
>  gpio: Add sysfs support to block GPIO API
>  gpio: Add userland device interface to block GPIO
>  gpiolib: Fix default attributes for class
>  gpio: Add device tree support to block GPIO API
>  gpio: Add block gpio to several gpio drivers
> 
>  Documentation/ABI/testing/dev-gpioblock               |   34 
>  Documentation/ABI/testing/sysfs-gpio                  |   31 
>  Documentation/devicetree/bindings/gpio/gpio-block.txt |   36 
>  Documentation/gpio.txt                                |   58 +
>  drivers/gpio/Makefile                                 |    1 
>  drivers/gpio/gpio-em.c                                |   23 
>  drivers/gpio/gpio-generic.c                           |   56 +
>  drivers/gpio/gpio-lpc32xx.c                           |   82 +
>  drivers/gpio/gpio-max730x.c                           |   61 +
>  drivers/gpio/gpio-max732x.c                           |   59 +
>  drivers/gpio/gpio-mm-lantiq.c                         |   22 
>  drivers/gpio/gpio-pca953x.c                           |   64 +
>  drivers/gpio/gpio-pcf857x.c                           |   24 
>  drivers/gpio/gpio-pch.c                               |   27 
>  drivers/gpio/gpio-pl061.c                             |   17 
>  drivers/gpio/gpio-sa1100.c                            |   20 
>  drivers/gpio/gpio-samsung.c                           |   31 
>  drivers/gpio/gpio-twl6040.c                           |   32 
>  drivers/gpio/gpio-ucb1400.c                           |   23 
>  drivers/gpio/gpio-vt8500.c                            |   24 
>  drivers/gpio/gpio-xilinx.c                            |   44 +
>  drivers/gpio/gpioblock-of.c                           |  100 ++
>  drivers/gpio/gpiolib.c                                |  782 ++++++++++++++++--
>  drivers/pinctrl/pinctrl-nomadik.c                     |   36 
>  include/asm-generic/gpio.h                            |   28 
>  include/linux/gpio.h                                  |  125 ++
>  26 files changed, 1793 insertions(+), 47 deletions(-)
