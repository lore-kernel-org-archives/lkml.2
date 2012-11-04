Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2KDSQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:16:20 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62014 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2KDSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121102000902.GA21574@dev.danweeks.net>
References: <20121102000902.GA21574@dev.danweeks.net>
Date: Sun, 4 Nov 2012 19:16:17 +0100
Message-ID: <CACRpkda932GWz=kyKOv8940jDCHu3Qu0ALvD9cCi++s5VWOWUA@mail.gmail.com>
Subject: Re: [PATCH] gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m
From: Linus Walleij <linus.walleij@linaro.org>
To: "Daniel M. Weeks" <dan@danweeks.net>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 1:09 AM, Daniel M. Weeks <dan@danweeks.net> wrote:

> The driver has both SPI and I2C pieces. The appropriate pieces are built based
> on whether SPI and/or I2C is/are enabled. However, it was only checking if I2C
> was built-in, never if it was built as a module. This patch checks for either
> since building both this driver and I2C as modules is possible.

Good catch!

> -#ifdef CONFIG_I2C
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

But don't do it like this, there are already helpers for exactly this.

Do:

#if IS_ENABLED(CONFIG_I2C)

Read include/linux/kconfig.h if in doubt...

Looking forward to v2!

Yours,
Linus Walleij
