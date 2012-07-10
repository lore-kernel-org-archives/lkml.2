Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2GJLya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:54:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41953 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab2GJLy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:54:28 -0400
Date: Tue, 10 Jul 2012 12:54:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Hilman <khilman@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers/rtc/rtc-twl.c: fix threaded IRQ to use
 IRQF_ONESHOT
Message-ID: <20120710115418.GA2280@sirena.org.uk>
References: <1341592434-4207-1-git-send-email-khilman@ti.com>
 <20120709151527.58f44c3a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709151527.58f44c3a.akpm@linux-foundation.org>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:15:27PM -0700, Andrew Morton wrote:

> OK, this is the second such patch I've seen and it's time to wonder if
> we should get grumpy at tglx.  afacit 1c6c6952 broke the following
> drivers:

> sound/soc/codecs/wm8994.c
> drivers/mfd/wm831x-auxadc.c
> drivers/mfd/wm8350-core.c
> drivers/regulator/wm831x-isink.c
> drivers/regulator/wm831x-ldo.c
> drivers/regulator/wm831x-dcdc.c
> drivers/input/misc/wm831x-on.c

> what am I missing here?

At least the above (and possibly a good proportion of the others from
the looks of things) aren't affected by this change because they are
nested IRQs for MFDs where we can guarantee that there will never be a
primary IRQ.  _ONESHOT shouldn't make any odds in these situations.

> drivers/base/regmap/regmap-irq.c

This is using irq_flags passed in by the caller so should be unaffected,
it's always been the responsibility of the caller to set the flags.
