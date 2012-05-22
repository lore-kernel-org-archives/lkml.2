Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab2EVA4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:56:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2EVA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:56:29 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Tue, 22 May 2012 10:53:21 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?utf-8?q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
In-Reply-To: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205221053.21792.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Tuesday, May 22, 2012 02:06:55 AM Fabio Estevam wrote:
> Hi Marc,
> 
> I am running linux-next 3.4.0-next-20120521 on a mx31pdk board that
> has a mc13783 PMIC connected to SPI.
> 
> I am getting a kernel hang after 'regmap_read' inside mc13xxx_reg_read
> function.
> 
> Does it work fine for you on your mx35 board? Am I missing any recent
> patch?

I tested linux-next/next-20120521, no extra patches. I got build errors for 
something to do with usb udc, and start-up panic for the nand driver. 
Disabling both of these got me to a login. Then:

mount -t debugfs none /sys/kernel/debug
cat /sys/kernel/debug/regmap/0-0008/registers

00: 004cc0
01: ffffff
02: 185cc0
03: 000005
04: ffffff
05: 00401c
06: 000200
07: 0045d0
08: 000000
09: 000005
0a: 00147a
0b: 000000
0c: 000000
0d: 0b0040
0e: 000000
0f: 400032
10: 000000
11: 000000
12: 000001
13: 000000
14: 013326
15: 01ffff
...

Which looks correct.


> 
> My understanding is that you have only tested i2c connection with this
> PMIC. Is this correct?
That's correct. I don't have any SPI connected hardware to test with. Shawn 
tested SPI operation for an earlier version of the patch series, but that was 
before the regmap changes.


> Any ideas on how to solve this issue is appreciated.
My first suspicion is with the regmap register format of the mc13xxx for SPI. 
It was a new format which introduced a padding bit. I wonder if Mark Brown can 
comment on whether any other devices are using it successfully. (Sorry I can't 
offer more insights there).

Does your crash occur during mc13xxx_spi_probe? does mc13xxx_common_init() get 
called?


Cheers,
Marc

