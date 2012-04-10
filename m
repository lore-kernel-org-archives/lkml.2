Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab2DJPOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:14:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54570 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085Ab2DJPO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:14:29 -0400
Message-ID: <4F844E52.3080902@wwwdotorg.org>
Date: Tue, 10 Apr 2012 09:14:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] pinctrl: fix build failure on PPC
References: <1334044357-14486-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1334044357-14486-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 01:52 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> commit 23289e6ecc6d ("pinctrl: core device tree mapping table
> parsing support") caused a build failure on PPC:
> 
> drivers/pinctrl/devicetree.c: In function 'dt_free_map':
> drivers/pinctrl/devicetree.c:44:42: error: dereferencing pointer to incomplete type
> drivers/pinctrl/devicetree.c:45:6: error: dereferencing pointer to incomplete type
> drivers/pinctrl/devicetree.c: In function 'dt_to_map_one_config':
> drivers/pinctrl/devicetree.c:140:21: error: dereferencing pointer to incomplete type
> drivers/pinctrl/devicetree.c:141:10: error: dereferencing pointer to incomplete type
> drivers/pinctrl/devicetree.c:146:11: error: dereferencing pointer to incomplete type
> 
> This is probably because the Makefile for pinctrl contains this,
> that makes a small piece of the implementation build and link
> in isolation:
> 
> obj-$(CONFIG_OF)                += devicetree.o
> 
> So let's use some local Kconfig option that depends on both OF
> and PINCTRL so that this file is only compiled if you have
> both enabled.

It seems simpler to just fix the Makefile to only compile the file when
its needed directly, without introducing a new Kconfig option. See
https://lkml.org/lkml/2012/4/3/445.
