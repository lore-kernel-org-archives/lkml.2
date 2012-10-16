Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab2JPASX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:18:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35025 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2JPASW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:18:22 -0400
Message-ID: <507CA7C7.6060405@gmail.com>
Date: Tue, 16 Oct 2012 11:18:15 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, gregkh@linuxfoundation.org
Subject: Re: [PATCH RFC 01/11 v4] gpio: Add a block GPIO API to gpiolib
References: <1350343887-7344-1-git-send-email-stigge@antcom.de> <1350343887-7344-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1350343887-7344-2-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/12 10:31, Roland Stigge wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
> 
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
> Once requested, it provides access to a group of GPIOs which can range over
> multiple GPIO chips.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---

<snip>

> +This creates a new block of GPIOs as a list of GPIO numbers with the specified
> +size which are accessible via the returned struct gpio_block and the accessor
> +functions described below. Please note that you need to request the GPIOs
> +separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
> +specified, even ranging over several gpio_chips. Actual handling of I/O
> +operations will be done on a best effort base, i.e. simultaneous I/O only where
> +possible by hardware and implemented in the respective GPIO driver. The number
> +of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
> +system. However, several blocks can be defined at once.

This should probably say that the number of gpios in a block is limited
to sizeof(unsigned long) or BITS_PER_LONG. I think sizeof(unsigned long)
== 8 on some 32 bit architectures.

~Ryan

