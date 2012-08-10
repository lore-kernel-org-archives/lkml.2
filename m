Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab2HJO1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:27:00 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41033 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab2HJO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:26:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120810140406.GB3409@S2101-09.ap.freescale.net>
References: <1344375978-29981-1-git-send-email-matt@genesi-usa.com>
 <20120808151555.GE14718@S2101-09.ap.freescale.net> <CAKGA1bkbp8_z+HSr97cp_jeCrdTHkQxuZPFu0QPWwnXphWVdZA@mail.gmail.com>
 <CAOMZO5DOEfV4wTSNW8ABaUhGwa_KG3Bkt0o-rs8k-cZk4P-=+A@mail.gmail.com>
 <CAKGA1bkOo=En2P18FaBpq_KAZ88kisikXhNTabvnDknQ-EwFjA@mail.gmail.com>
 <20120810014119.GD19617@S2101-09.ap.freescale.net> <CAKGA1bmd-53G=59F7Nsd3Sx2eEQgvcahnt3g5zxJAGawtc-gWQ@mail.gmail.com>
 <20120810140406.GB3409@S2101-09.ap.freescale.net>
From: Matt Sealey <matt@genesi-usa.com>
Date: Fri, 10 Aug 2012 09:26:36 -0500
Message-ID: <CAKGA1b=bcV2RKDvv=hTjfCo+uTXgcvsTPP0pM-vZYUHLMcrRvg@mail.gmail.com>
Subject: Re: [PATCH] efikamx: reintroduce Genesi Efika MX Smarttop via device tree
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 9:04 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Fri, Aug 10, 2012 at 08:36:02AM -0500, Matt Sealey wrote:
>> Requiring it breaks the entire concept of the device tree to describe running
>> hardware. It is not a configuration script. pinctrl should be optional
>> - built in
>> always, but not necessary to turn a board on if it's already configured.
>>
> How would kernel know if it's already configured, correctly?

Trust! When we release the new U-Boot, it will be already configured,
every pin in the schematic, every
pin from the old kernels (not mainline, some of that was wrong),
exactly the way it should be. There's
nothing new with the Efika MX.

If you try and boot it on the old Efika, it just won't work reliably
for any peripheral U-Boot didn't
already configure, but for the current version you'd get MMC, PATA,
serial port, SPI (NOR/PMIC)
which is all we configure in the DT right now anyway... this is only
going to be an issue once we
get to displays and USB (I2C isn't set up in the old one).

>> What would happen if a board were designed that only used the default ALT
>> settings on i.MX53 or so? You'd have to redefine every default IOMUX pad
>> just to get it to boot. That's intolerable.
>
> Come on, even the pad configuration are all the default?  Even if that's
> the case, yes, we still need to do it.  How do we know if firmware has
> changed the settings or not.

TRUST...

Maybe you can't rely on the development boards from Freescale, but we have to
do unit testing at every stage of operation for consumer devices. Once U-Boot
passes all tests, why bother re-testing the exact same configuration, now done
twice, in the kernel? I don't want to debug pad settings twice, and we shouldn't
need to.

If you really think it's necessary then fine, we'll do it.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
