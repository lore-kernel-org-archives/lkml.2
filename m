Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2CAUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:40:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab2CAUka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:40:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Date: Thu, 1 Mar 2012 20:40:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-9-git-send-email-alan@signal11.us> <CACRpkdZK+9gF7N2akyWw=tvcBS2X2FmSd2-SiNKiuRgUCYXx7w@mail.gmail.com>
In-Reply-To: <CACRpkdZK+9gF7N2akyWw=tvcBS2X2FmSd2-SiNKiuRgUCYXx7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012040.18158.arnd@arndb.de>
X-Provags-ID: V02:K0:BYepvyfsK/lgb2epAWEEXkipjRjw8BZoI4rDWGeNOQR
 XFwXVwt8PGccWtGbePZGXwIEAxitbdLTaalRe955W7OehhPcOz
 L6QLEIjKhDa7+9ZOtZ1G6T4rZJrhBYsNYUFUMsBbPGdCKaxsbE
 rXu0BD+CT734pQ2cnzX8qWxpRqaylpHjd/SYB21eqUFJWP4QYe
 RQV1i+JZwrsm9Tm8rFOiT6Xao/zCyjHDAact498LyhS3xxdfCY
 T7jmfhqUoompV1SIfzxkSQpDGPDL2n3qlHTXtnzfzdLwfgyEIU
 5MgJpdrpoJYAEY1fefD+GH/4cz2p9NI9ZkVS2QQuhDwnuJfmE4
 c2Xl1On3sbRgDhtXl31E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Linus Walleij wrote:
> The kernel is full of this kind of stuff (drivers/mfd/twl4030-irq.c):
> 
> #ifdef CONFIG_ARM
>         /* ARM requires an extra step to clear IRQ_NOREQUEST, which it
>          * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
>          */
>         set_irq_flags(irq, IRQF_VALID);
> #else
>         /* same effect on other architectures */
>         irq_set_noprobe(irq);
> #endif

That is the implementation of an irq_chip, not a random device driver.

	Arnd
