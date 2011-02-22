Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1BVOWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:22:55 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:52495 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1BVOWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:22:54 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <015101cbcdae$3b4fcc00$b1ef6400$@mprc.pku.edu.cn> <201102171840.16430.arnd@arndb.de>
In-Reply-To: <201102171840.16430.arnd@arndb.de>
Subject: RE: [PATCH 08/12] unicore32 machine related files: core files
Date: Tue, 22 Feb 2011 22:22:46 +0800
Message-ID: <018e01cbd29b$fa19cdb0$ee4d6910$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFjPA5SX30r5WoPjFYZ+LMbRYC0WwJFY8qIlMyUA9A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:40 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 08/12] unicore32 machine related files: core files
> 
> On Wednesday 16 February 2011, Guan Xuetao wrote:
> > Message-Id: <15f7e89c92883a77c96f5f3288c9a4afbd68f8e3.1297842537.git.gxt@mprc.pku.edu.cn>
> > In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
> > References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
> > From: GuanXuetao <gxt@mprc.pku.edu.cn>
> > Date: Sat, 15 Jan 2011 18:24:16 +0800
> 
> These headers should not be here. When using git-send-email, this will be handled
> automatically, but if you send the patch from a regular email client application,
> you should remove them manually.
> 
> > diff --git a/arch/unicore32/Kconfig.puv3 b/arch/unicore32/Kconfig.puv3
> > new file mode 100644
> > index 0000000..2ef10db
> > --- /dev/null
> > +++ b/arch/unicore32/Kconfig.puv3
> > @@ -0,0 +1,125 @@
> > +#
> > +# PKUnity v3 Kconfig
> > +#
> > +
> > +if ARCH_PUV3
> > +
> > +menu "PKUnity v3 SoC Features"
> > +
> > +config PUV3_I2C
> > +	bool "PKUnity v3 I2C bus support"
> > +#	default y
> > +	select I2C
> > +	select I2C_CHARDEV
> > +	select I2C_ALGOBIT
> > +
> > +config PUV3_UMAL
> > +	tristate "PKUnity v3 UMAL Gigabit Network Adapter support"
> > +	select MII
> > +	select PHYLIB
> > ...
> 
> Generally, everything in this file should be moved to other files.
> The rule is that the Kconfig entry belongs into the same directory
> as the Makefile referencing it. E.g. the two above should
> be in drivers/i2c/busses/Kconfig and drivers/net/Kconfig, and in
> the same patch as the actual device driver.
> 
> > +
> > +static struct platform_device nb0916_device_gpio_button = {
> > +	.name	= "gpio-keys",
> > +	.id	= -1,
> > +	.dev	= {
> > +		.platform_data = &nb0916_gpio_button_data,
> > +	},
> > +};
> > +
> > +static struct platform_device *mach_nb0916_devices[] __initdata = {
> > +	&puv3_device_i2c,
> > +	&physmap_flash,
> > +	&nb0916_device_backlight,
> > +	&nb0916_device_gpio_button,
> > +};
> 
> Static platform devices are no longer recommended. You can change these
> to use platform_device_register_simple() or a variant of it.
> 
> If you plan to convert the entire architecture to use a flattened
> device tree as we discussed in an earlier review, you don't need to
> bother with this now, because the entire platform device registration
> you have here can then be removed.
Above two files are no used in new reviewed version, and they were removed.

> 
> 	Arnd
Thanks Arnd

Guan Xuetao

