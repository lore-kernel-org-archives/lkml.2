Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2B1GiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:38:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2B1GiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:38:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Wells <kevin.wells@nxp.com>
Subject: Re: [PATCH v3] ARM: LPC32xx: Ethernet support
Date: Tue, 28 Feb 2012 06:38:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1330364762-23203-1-git-send-email-stigge@antcom.de> <4F4BFDD2.8060007@antcom.de> <083DF309106F364B939360100EC290F81F365B2B2A@eu1rdcrdc1wx030.exi.nxp.com>
In-Reply-To: <083DF309106F364B939360100EC290F81F365B2B2A@eu1rdcrdc1wx030.exi.nxp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202280638.04634.arnd@arndb.de>
X-Provags-ID: V02:K0:GhssLNmpVKss5K8MY20TRt7jOpWFp+CQ9o40ScSFWKv
 0wgLHi47wX1agGGPJpqJ6ozxm7DCQYNISlKz7sUK4LD2X0+9Gu
 TICXRFwcoS/PSoC1giEBoEwLaVdFFqHW/Crg4teFLJOaVHJv9h
 q34/Xc8itX9h+hdwzKDZ6OPoamp/HCHoa+Is0HvvVrlqxJri2A
 3RGPZlpvxw/vdV4ULQY+wD9DHAb/5WbhBEes5fh7FWRJdCy48U
 gB0w/iH1TGRSPOYWRF+yumJqRpV2XsJc9BZoMEslKY7buSO89c
 lFaw9hoVdXiphWgKMhv/Zs2sNo9k60S0BJJQr5+hVxkmkzy8eR
 qXeUhSq5roLkc/U6GJTE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 February 2012, Kevin Wells wrote:
> >
> >For the driver, some style fixes were applied, and the cmdline
> >"ethaddr" was removed, relying on the bootloader to set it correctly
> > (and it actually does, it actually needs to prepare TFTP booting).
> 
> I'm not sure I'd trust the bootloader to always set the MAC address
> in hardware prior to calling the kernel. A lot of u-boot MAC drivers,
> including the 32x0's, only set the MAC address on the call to
> eth_init(), which is only called when the network interface is used.
> If you do a MTD based kernel boot, the MAC address will probably be
> invalid if you try to do a NFS mount for the filesystem.

In the long run, the MAC address should probably be set by the boot
loader through the device tree that is passed to the kernel, overriding
the one in the registers when set.

When we do that, we won't need the command line argument any more.
Some drivers have it anyway, but IMHO the cleaner approach would
be having fewer methods to pass it.

	Arnd
