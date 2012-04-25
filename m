Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab2DYLTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:19:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34265 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab2DYLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120425094934.GA17631@shlinux2.ap.freescale.net>
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
	<4F96F847.508@wwwdotorg.org>
	<20120425094934.GA17631@shlinux2.ap.freescale.net>
Date: Wed, 25 Apr 2012 13:19:43 +0200
Message-ID: <CACRpkdYjVYsM-Qo7NWKx5Mr3rAmp12G_wAtkmNkkqNyX=ZeKUw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pinctrl: add pinctrl_provide_dummies interface for
 platforms to use
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 11:49 AM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> On Wed, Apr 25, 2012 at 03:00:23AM +0800, Stephen Warren wrote:

>> The only thing that should be calling pinctrl_request_gpio() is a GPIO
>> driver. It should only be calling it for the GPIOs it manages. I'd
>> expect that if a platform's pinctrl driver was not yet written to
>> support the GPIO functionality, then the GPIO driver would not be
>> calling this function.
>>
> Hmm, pinctrl gpio is in the same situation as pinctrl state that gpio
> driver may be shared between several platforms, with pinctrl support
> or not.

I think it's mostly safe to assume that either:

- pinctrl calls from GPIO drivers gets stubbed out totally due to
  CONFIG_PINCTRL not being selected

or:

- You need to pass a token through platform data to the
  GPIO driver telling it whether it needs to request pins for
  it's GPIOs or not. Just a bool should work fine?

Linus Walleij
