Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab2DTEdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 00:33:08 -0400
Received: from 11.mo3.mail-out.ovh.net ([87.98.184.158]:47585 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724Ab2DTEdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 00:33:07 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 00:33:06 EDT
Date: Fri, 20 Apr 2012 03:08:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dongas86@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 3/3] ARM: imx6q: switch to use pinctrl driver
Message-ID: <20120420010845.GV16641@game.jcrosoft.org>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <1334333915-1174-3-git-send-email-b29396@freescale.com>
 <20120414135331.GB3852@pengutronix.de>
 <CAA+hA=QhSUZg0bWTss_4ROwZ--OOQfcP=mpt+MP7-ZKPkEwXyA@mail.gmail.com>
 <20120415073751.GF24997@S2101-09.ap.freescale.net>
 <20120416033519.GA17173@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416033519.GA17173@shlinux2.ap.freescale.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13511924783436311533
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegfedrfeelucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:35 Mon 16 Apr     , Dong Aisheng wrote:
> On Sun, Apr 15, 2012 at 03:37:54PM +0800, Shawn Guo wrote:
> > On Sun, Apr 15, 2012 at 12:03:16PM +0800, Dong Aisheng wrote:
> > ...
> > > For MX3 and MX5, before their pinctrl driver are available, user may
> > > need to define a dummy in dt to avoid such an error.
> > > 
> > That is insane, and will not work.
> > 
> > 1) We do not have device tree support for MX3 yet.
> > 2) It's not practical to add dummy entries in dt to avoid the error.
> > 3) There are still so many non-dt board files support in the tree.
> > How will they work with that?
> > 
> > My suggestion is to not make it an error but a dev_dbg, assuming that
> > the pins are already set up by platform code if we do not find the
> > entry from pinctrl system.  We can take it as a transition solution,
> > and turn the dev_dbg back to error when all the users of the device
> > driver are converted to device tree.
> > 
> My thinking is let pinctrl core handle dummy state as regulator subsystem
> and does not depend on dt.
> Linus, Stephen, any comment?
agreed with Shawn

this is insane if you can an error you do need to report it

I get the same issue on at91 and I'm going to make the pinctrl mandatory for DT
only

Best Regards,
J.
