Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2HAP7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:59:00 -0400
Received: from bar.sig21.net ([80.81.252.164]:37270 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab2HAP65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:58:57 -0400
X-Greylist: delayed 2168 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 11:58:57 EDT
Date: Wed, 1 Aug 2012 17:22:40 +0200
From: Johannes Stezenbach <js@sig21.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: DT GPIO numbering?
Message-ID: <20120801152240.GA16388@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently learning how Linux devicetree support works,
here is one question I couldn't find an answer for.

I understand that within the devicetree GPIOs are referenced by phandle,
thus the numbers are irrelevant.  However, in sysfs the number is
what is used to access the GPIO, e.g. for debugging or
blinkenlight apps.  How does this fit together?

In the old days platform data was used, e.g.

	struct pl061_platform_data {
		/* number of the first GPIO */
		unsigned	gpio_base;
		...
	};

Now, when DT is used gpio-pl061.c sets gc.base = -1 (dynamic numbering).

Should there be a DT property to assign the number base?

Or is there some better way, e.g. in gpio-mxs.c the code derives
the gc.base from of_alias_get_id(np, "gpio").
Should gpio-pl061.c do the same?

And how about assigning gpio names?  When a name is assigned to
the GPIO, is shows up in sysfs instead of gpio%d, however the
number is still needed for /sys/class/gpio/export, right?


Thanks,
Johannes
