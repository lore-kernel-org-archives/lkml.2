Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2IMHTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:19:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7213 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2IMHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:19:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Sep 2012 00:18:42 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Date: Thu, 13 Sep 2012 16:21:28 +0900
Message-ID: <2382448.ok7bO52bKX@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1347519807.7471.45.camel@lappyti>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <20120913070012.GC6180@pengutronix.de> <1347519807.7471.45.camel@lappyti>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012 15:03:27 Tomi Valkeinen wrote:
> * PGP Signed by an unknown key
> 
> On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> 
> > On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > 
> > > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > 
> > > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > > 
> > > >  
> > > >  
> > > > > However, I fear these board specific things may be quite a bit
> > > > > anything,
> > > > > so it may well be pwm, gpios and regulators are not enough for them.
> > > > > For
> > > > > example, there could be an FPGA on the board which requires some
> > > > > configuration to accomplish the task at hand. It could be rather
> > > > > difficult to handle it with a generic power sequence.
> > > > 
> > > > 
> > > > Right. Note that this framework is supposed to be extended - I would
> > > > like to 
 at least add regulator voltage setting, and maybe even
> > > > support for clocks and pinmux (but that might be out of place).
> > > 
> > > 
> > > Yes, that's one concern of mine... I already can imagine someone
> > > suggesting adding conditionals to the power sequence data. Perhaps also
> > > direct memory read/writes so you can twiddle registers directly. And so
> > > on. Where's the limit what it should contain? Can we soon write full
> > > drivers with the DT data? =)
> > 
> > 
> > I have this concern aswell, that's why I'm sceptical about this patch
> > set. But what are the alternatives? Adding power code to the drivers and
> > thus adding board specific code to them is backwards.
> 
> 
> As was pointed out in earlier posts in this thread, these are almost
> always device specific, not board specific.

I think the confusion comes from the fact that in practice, people just wrote 
their hooks into the board files instead of writing more "specialized" drivers 
(which I agree would have been the correct way of doing). That is why hooks 
like those of the pwm_backlight driver were "board specific code" to me too.

Alex.

