Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2DQTuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:50:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43649 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2DQTuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <1334688545-8465-2-git-send-email-swarren@wwwdotorg.org>
References: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org>
	<1334688545-8465-2-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 17 Apr 2012 21:50:02 +0200
Message-ID: <CACRpkdbqE7H7Q1xUeFQL3DmgoKF6HNbWp-DswYKqMVK12tVSVw@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c: Add generic I2C multiplexer using pinctrl API
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 8:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> This is useful for SoCs whose I2C module's signals can be routed to
> different sets of pins at run-time, using the pinctrl API.
>
>                                 +-----+  +-----+
>                                 | dev |  | dev |
>    +------------------------+   +-----+  +-----+
>    | SoC                    |      |        |
>    |                   /----|------+--------+
>    |   +---+   +------+     | child bus A, on first set of pins
>    |   |I2C|---|Pinmux|     |
>    |   +---+   +------+     | child bus B, on second set of pins
>    |                   \----|------+--------+--------+
>    |                        |      |        |        |
>    +------------------------+  +-----+  +-----+  +-----+
>                                | dev |  | dev |  | dev |
>                                +-----+  +-----+  +-----+
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

I remember you told me about this thing, it's really fascinating!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

> Note: This patch depends on the latest pinctrl tree. In order to merge
> this series into the I2C tree, you'll need to merge the pinctrl tree
> into it first. However, the pinctrl tree doesn't yet have a stable tag/branch
> that you can merge, so this patch can't actually be committed yet.

I'll create a tag once I have the devm* stuff in place (it's so
good we just have to have it).

BTW another way is to have this ACK:ed by Jean/Dooks/Wolfram
and I just put it in the pinctrl tree, unless there is something
radical happening in the mux part of the I2C tree this merge
window?

Yours,
Linus Walleij
