Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2KVWCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:36 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Wed, 21 Nov 2012 22:31:15 +0100
Message-ID: <79636467.nuLQX2FqW5@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 20, 2012 08:13:29 PM Mika Westerberg wrote:
> This is fourth version of the series. I've based these on top of Rafael's
> "simplify glueing ACPI handles to physical nodes" available from here:
> 
> 	https://lkml.org/lkml/2012/11/19/588
> 
> There is a dependency to linux-pm tree and to the above patches so I
> propose to merge these via that same tree. Subsystem maintainers, can you
> ack these if you think that they are a suitable shape?
> 
> Changes to v3:
> 	- simplify acpi_gpiochip_find()
> 	- acpi_spi/i2c_add_resource() uses acpi_dev_resource_interrupt()
> 	  directly instead of first checking the resource type
> 	- acpi_spi/i2c_add_device() calls acpi_dev_free_resource_list()
> 	  immediately after walking the resources and get rid of
> 	  fail_put_dev label.
> 
> Changes to v2:
> 	- drop the ACPI ->find_device() glue magic in preference of the new
> 	  simplified mechanism where we just assign the ACPI handle
> 	- correct the IRQ resource handling to take the first resource and
> 	  skip the rest
> 	- moved declaration of acpi_i2c_register_devices() to i2c.h instead
> 	  of having a separate header for a single function
> 
> Changes to the original version:
> 	[gpio]
> 	- CONFIG_GPIO_ACPI instead of CONFIG_ACPI_GPIO
> 	- removed redundant test in acpi_gpiochip_find()
> 
> 	[spi and i2c]
> 	- switched to use ACPI centralized _CRS evaluation framework
> 	  introduced by Rafael 
> 	- dropped request_module() call
> 	- dropped the acpi_enumerate_spi/i2c_device()
> 	- added required includes and dropped <linux/acpi.h> from
> 	  acpi_i2c.h
> 
> Thanks.
> 
> Mathias Nyman (1):
>   gpio / ACPI: add ACPI support
> 
> Mika Westerberg (2):
>   spi / ACPI: add ACPI enumeration support
>   i2c / ACPI: add ACPI enumeration support

This patchset has been around for quite a while and went through a few
iterations, so I think it's as good as it gets at this point.

I wonder if the GPIO / SPI / I2C maintainers have any objections against it or
would like the patches to be modified somehow?

If not, then I'd like to take it for v3.8 into the linux-pm.git tree, because
the patches depend on some changes already in that tree.  Hopefully, that's OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
