Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1C3K7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:59:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1C3K7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:59:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Wed, 30 Mar 2011 12:59:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        m-watkins@ti.com, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <201103111628.57549.arnd@arndb.de> <17BF3847C06240EC921FB684D3120DEC@subhasishg>
In-Reply-To: <17BF3847C06240EC921FB684D3120DEC@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301259.28483.arnd@arndb.de>
X-Provags-ID: V02:K0:VAHQIV1zpdsV8eAIuF8vIVZfOy21Xsewma8ODT6Gf7Y
 0efCLpUHzytIj2PUU4yhqybfgx9lfbwoCHAjUM1CX72nLpex2X
 UlJDzy9cTjjCGxFOmyXZn9dLxOpB8hicUL+F4l3a4wmy+Z+9YH
 nMtSaXaH51IrP6HLAhrmZpu8dzNqBnFXzH7yj5E7STEApY3lis
 u8p31HL/TcjKdmhI2KXHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Subhasish Ghosh wrote:
> 
> >> +s32 pruss_disable(struct device *dev, u8 pruss_num)
> >> +{
> >> + struct da8xx_pruss *pruss = dev_get_drvdata(dev->parent);
> >> + struct da8xx_prusscore_regs *h_pruss;
> >> + struct pruss_map *pruss_mmap = (struct pruss_map *)pruss->ioaddr;
> >> + u32 temp_reg;
> >> + u32 delay_cnt;
> >
> > Can you explain the significance of pruss_num? As far as I
> > can tell, you always pass constants in here, so it should
> > be possible to determine the number from the device.
> 
> SG - The number is not programmed in the device, I need something to decide 
> which PRU to disable or enable.

I still don't understand. Please explain how the devices
relate to the multiple PRUs in hardware. 

> >> + for (loop = 0; loop < bytestowrite; loop++)
> >> + __raw_writeb(*pdatatowrite++, paddresstowrite++);
> >> +
> >> + return 0;
> >> +}
> >> +EXPORT_SYMBOL(pruss_writeb);
> >
> > I would recommend providing a simpler variant of your all I/O accessors,
> > which write a single word. Most of the users of these simply
> > pass bytestowrite=1 anyway, so the caller can become more readable.
> 
> SG - At some sections in the code I am using upto 8 bytescount.
>             If its ok, I would want to keep it as is.

You can of course have both, but I would recommend making the common
case simpler by providing a version that writes just one word.

	Arnd
