Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2AZNO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:14:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53454 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2AZNO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:14:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120125220824.GW22818@atomide.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
	<20120120161730.21955.40332.stgit@kaulin.local>
	<74CDBE0F657A3D45AFBB94109FB122FF1780DAB384@HQMAIL01.nvidia.com>
	<20120120174157.GQ22818@atomide.com>
	<20120125220824.GW22818@atomide.com>
Date: Thu, 26 Jan 2012 14:14:55 +0100
Message-ID: <CACRpkdYnC9smbM+WeYxahZGbevFiYyMRbyPKS+Y1YNryH_27iw@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: Add checks for empty names in pinmux_search_function
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:08 PM, Tony Lindgren <tony@atomide.com> wrote:

> This is needed as otherwise we can get the following when dealing
> with buggy data in a pinmux driver for pinmux_search_function:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ...
> PC is at strcmp+0xc/0x34
> LR is at pinmux_get+0x350/0x8f4
> ...
>
> As we need pctldev initialized to call ops->list_functions, let's
> initialize it before check_ops calls and pass the pctldev to the
> check_ops functions. Do this for both pinmux and pinconf check_ops
> functions.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

This looks correct to me, so applied it and pushed to -next
for testing.

Yours,
Linus Walleij
