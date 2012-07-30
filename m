Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2G3PBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:01:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39262 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab2G3PBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:01:32 -0400
Date: Mon, 30 Jul 2012 16:01:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
Message-ID: <20120730150129.GF4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-6-git-send-email-lee.jones@linaro.org>
 <20120729204218.GI4384@opensource.wolfsonmicro.com>
 <50162F70.2050900@linaro.org>
 <20120730133930.GB4468@opensource.wolfsonmicro.com>
 <501692B8.6050102@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501692B8.6050102@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 02:57:12PM +0100, Lee Jones wrote:
> On 30/07/12 14:39, Mark Brown wrote:

> >Why does the driver care - doesn't the pinctrl abstraction and/or
> >bindings handle this sensibly?

> Not when I tested it. pinctrl_get() came back !IS_ERR() for MSP0,
> MSP2 & MSP3, then when it went on to pinctrl_lookup_state(), only
> then did it fail. Would it be more sane to retract the error
> messages and just let it fail silently? It's either that or have
> lots of "could not get MSP defstate" clogging up the log.

This sounds to me like we should be ensuring that there's a single
fixed state available for these MSPs (representing the fact that the
pins are always in the right mode) in the pinctrl bindings.

As with several of other changes for this platform it seems like we need
to think carefully about the abstraction level we're working at.
