Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2GNWM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 18:12:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39439 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2GNWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 18:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <1342175967-10087-6-git-send-email-ldewangan@nvidia.com>
References: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>
	<1342175967-10087-6-git-send-email-ldewangan@nvidia.com>
Date: Sun, 15 Jul 2012 00:12:49 +0200
Message-ID: <CACRpkdZ-zsBKSwyzecOpsWyM0o6-EYQwrqWopzeQm1D0D6TaEg@mail.gmail.com>
Subject: Re: [PATCH 5/5] mfd: tps6586x: remove gpio support from core driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:39 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The GPIO functionality of device tps6586x is added through
> platform gpio driver and it can be register as the mfd sub
> device and hence removing the duplicates code which register
> the gpio functionality from core driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

The only thing I worry about is if old defconfig files are now
missing this config option and then this patch becomes an
unbisectable showstopper for them because they don't get
this driver by default anymore.

So please make sure you've grepped around and checked
that of some platforms defconfig was previously selecting
the core driver, make sure it selects this driver too for
the moment, it's better if they later deactivate it
if they don't need it.

Yours,
Linus Walleij
