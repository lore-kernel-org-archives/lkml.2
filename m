Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab1IZMv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:51:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1IZMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:51:58 -0400
Date: Mon, 26 Sep 2011 13:51:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add gpio based voltage switching regulator
Message-ID: <20110926125155.GH2946@opensource.wolfsonmicro.com>
References: <201109260852.19859.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201109260852.19859.heiko@sntech.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 08:52:18AM +0200, Heiko Stübner wrote:

> This patch adds support for regulators that can switch between
> two voltage levels by setting a gpio.

This really should be scalable beyond two voltages, or at least prepared
for that possibility.

> Handling of set_voltage calls with a range that fits neither the
> low nor the high voltage is determined by the inbetween_high
> option. When set to 1 the high voltage is used, on 0 the low
> voltage is used and on -EINVAL an error is returned, disallowing
> the usage of the voltage range.

No, don't do this.  If you can't set the requested voltage then fail.
This is not in the least bit driver specific.

> I'm not hung up on the "inbetween handling", in fact at the moment it
> seems to not belong there. But I'm not sure on how to handle
> frequency tables like
> 	[0] = { 1000000, 1150000 },
> 	[1] = { 1150000, 1250000 },
> 	[2] = { 1250000, 1350000 },
> I.e. the middle value should use the voltage in 2 for switch regulators,
> but the defined value for more intelligent ones.

I'm afraid I can't parse this, sorry.

> @@ -0,0 +1,320 @@
> +/*
> + * switched.c

This needs a better name.

Otherwise this looks good, the main thing is the ability to support more
voltages.
