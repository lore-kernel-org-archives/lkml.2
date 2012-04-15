Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2DOHht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 03:37:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52475 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2DOHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 03:37:48 -0400
Date: Sun, 15 Apr 2012 15:37:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: imx6q: switch to use pinctrl driver
Message-ID: <20120415073751.GF24997@S2101-09.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <1334333915-1174-3-git-send-email-b29396@freescale.com>
 <20120414135331.GB3852@pengutronix.de>
 <CAA+hA=QhSUZg0bWTss_4ROwZ--OOQfcP=mpt+MP7-ZKPkEwXyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=QhSUZg0bWTss_4ROwZ--OOQfcP=mpt+MP7-ZKPkEwXyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 12:03:16PM +0800, Dong Aisheng wrote:
...
> For MX3 and MX5, before their pinctrl driver are available, user may
> need to define a dummy in dt to avoid such an error.
> 
That is insane, and will not work.

1) We do not have device tree support for MX3 yet.
2) It's not practical to add dummy entries in dt to avoid the error.
3) There are still so many non-dt board files support in the tree.
How will they work with that?

My suggestion is to not make it an error but a dev_dbg, assuming that
the pins are already set up by platform code if we do not find the
entry from pinctrl system.  We can take it as a transition solution,
and turn the dev_dbg back to error when all the users of the device
driver are converted to device tree.

-- 
Regards,
Shawn
