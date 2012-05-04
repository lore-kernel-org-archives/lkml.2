Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2EDREV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:04:21 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:32831 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752478Ab2EDREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:04:20 -0400
Date: Fri, 4 May 2012 18:40:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>, Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504164045.GH7788@game.jcrosoft.org>
References: <201205031350.35476.arnd@arndb.de>
 <20120503140428.GB897@n2100.arm.linux.org.uk>
 <201205041220.24747.arnd@arndb.de>
 <4FA40642.5040203@gmail.com>
 <20120504165603.GK897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504165603.GK897@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 838795432560274355
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdehucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdehucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:56 Fri 04 May     , Russell King - ARM Linux wrote:
> On Fri, May 04, 2012 at 11:39:30AM -0500, Rob Herring wrote:
> > Many of the headers are simply platform_data structs which may still be
> > needed on DT platforms, but could be moved elsewhere.
> 
> Those should be in include/linux/platform.
> 
> > >> Then there's also the problem of uncompress.h.  The last piece of the
> > >> puzzle is the common clock stuff.
> > 
> > The smp/hotplug/localtimer related functions are still global. Marc Z
> > has posted patches for this, but I haven't seen recent activity. This
> > and clocks were the 2 main issues I saw trying to build 2 platforms
> > together. highbank and picoxcell could be built together since only
> > highbank has clocks and smp.
> > 
> > gpio.h is still required, but empty for most platforms.
> 
> Those empty gpio.h files are definitely a candidate for going into
> arch/arm/include/mach/gpio.h, and then all those 12-byte mach/gpio.h can
> be deleted (13 files).
> 
> We've not had any progress on the gpio.h issue since I did the last round
> of cleanup; the next stage was to persuade SoC maintainers to get rid of
> their optimized versions which aren't compatible with multi-platform
> kernels.
> 
> I don't know if folk are expecting me to push that forwards or whether
> there's someone else working on that aspect of it...
> 
> So this issue really does need to be progressed too.
on at91 as we clean it for DT we will be able to drop it soon too

Best Regards
J.
