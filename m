Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2BOWZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:25:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41413 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2BOWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:25:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120213211809.GI11077@ponder.secretlab.ca>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
	<1329114588-15430-3-git-send-email-ldewangan@nvidia.com>
	<20120213211809.GI11077@ponder.secretlab.ca>
Date: Wed, 15 Feb 2012 23:25:41 +0100
Message-ID: <CACRpkdZzcN5oi0ejeTQn3BNJ_w6XHsBQ_RoQMvpf8Lt2bOARAg@mail.gmail.com>
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: dunlap@xenotime.net, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 10:18 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:

> Linus mentioned that this should be part of pinctrl instead of the gpio API,
> but I think there is an argument for making it part of the gpio API,
> particularly since open-drain is pretty much a universal concept that all
> gpio controllers can support (unlike driver strength)

Actually pinctrl is engineered to be used as back-end for gpiolib
so thinking about it I'm pretty happy with this arrangement, the gpiolib
driver can very well call down to pinctrl to have the actual setting
done if needed. So it's no big deal.

It is also a case for making some of the pin config business
generic, which I have failed at in the past.

> Have you though about support for lines that are pulled low instead of
> high?  Those aren't as common, but it is conceivable that some
> hardware would need it.

So if the idea is (if I get it correctly) that this thing is an input
sometimes and open drain/collector output sometimes, then
open source/emitter for the inverse situation is an equally valid
case right? In that case I think it'd be best to add both.

The COH901 driver for U300 supports open source/emitter
BTW.

Yours,
Linus Walleij
