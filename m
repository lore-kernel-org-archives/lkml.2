Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2EHS4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:56:39 -0400
Received: from d1.icnet.pl ([212.160.220.21]:49806 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2EHS4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:56:38 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        linux-mtd@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3.4-rc6] MTD: NAND: ams-delta: fix request_mem_region() failure
Date: Tue, 08 May 2012 20:46:25 +0200
Message-ID: <13373590.4hsHpBS0MY@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <1336461106.23308.12.camel@sauron.fi.intel.com>
References: <20120504171125.GD5613@atomide.com> <1336460605.23308.8.camel@sauron.fi.intel.com> <1336461106.23308.12.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia wtorek, 8 maja 2012 10:11:46 Artem Bityutskiy pisze:
> On Tue, 2012-05-08 at 10:03 +0300, Artem Bityutskiy wrote:
> > On Mon, 2012-05-07 at 22:51 +0200, Janusz Krzysztofik wrote:
> > > A call to request_mem_region() has been introduced in the omap-
gpio
> > > driver recently (commit 96751fcbe5438e95514b025e9cee7a6d38038f40,
> > > "gpio/omap: Use devm_ API and add request_mem_region"). This 
change
> > > prevented the Amstrad Delta NAND driver, which was doing the same 
in
> > > order to take control over OMAP MPU I/O lines that the NAND device 
hangs
> > > off, from loading successfully.
> > 
> > Aiaiai found out that your patch adds this gcc warning:
> > 
> > 
--------------------------------------------------------------------------------
> > 
> > Successfully built configuration "l2_omap1_defconfig,arm,arm-unknown-
linux-gnueabi-", results:
> > 
> > --- before_patching.log
> > +++ after_patching.log
> > @@ @@
> > +drivers/mtd/nand/ams-delta.c: In function 'ams_delta_cleanup':
> > +drivers/mtd/nand/ams-delta.c:285:19: warning: unused variable 'res' 
[-Wunused-variable]
> > 
> > 
--------------------------------------------------------------------------------
> 
> But I've fixed this up and pushed to l2-mtd.git.

Many thanks for this.

> From the commit message
> I have an impression that you are not going to implement that longer
> term plan.

I just didn't state 'I'll do it for the next merge window' because my 
spare time resources are limited, and I've at least one set of changes 
to the Amstrad Delta code still waiting on my todo list.

I'll try to implement that long term plan as my spare time permits.

Thanks,
Janusz
