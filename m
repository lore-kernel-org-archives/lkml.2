Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1D0SYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:24:10 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:23736 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab1D0SYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:24:05 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1303928639!17849677!30
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Date: Wed, 27 Apr 2011 13:23:37 -0500
Subject: RE: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Topic: [PATCH 02/10] mach-u300: rewrite gpio driver, move to
 drivers/gpio
Thread-Index: AcwE3YXilYJbvEAoRTOVA3uzSnrLrQAKdGDg
Message-ID: <0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 27, 2011 6:13 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This rewrites the U300 GPIO driver using gpiolib and the irq_chip
> abstractions, makes it runtime-configured rather than compile-time,
> and moves it to the drivers/gpio subsystem where it belongs,
> depopulating the ARM tree of one more driver.
>
> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

If this and other platform-specific GPIO drivers are going to be
moved to the drivers/gpio subsystem, the Kconfig and Makefile should
probably be updated to reflect this.

In drivers/gpio/Kconfig:

#
# platform-neutral GPIO infrastructure and expanders
#

And in drivers/gpio/Makefile:

# generic gpio support: dedicated expander chips, etc
#
# NOTE: platform-specific GPIO drivers don't belong in the
# drivers/gpio directory; put them with other platform setup
# code, IRQ controllers, board init, etc.

The Makefile should probably be reordered, either alphabetically
or grouped by type (arch/mmio/i2c/spi/pci/etc) and then
alphabetically in order to reduce merge conflicts.

Regards,
Hartley