Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2IMGef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:34:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3431 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2IMGe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:34:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 12 Sep 2012 23:33:37 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Stephen Warren <swarren@nvidia.com>,
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
Date: Thu, 13 Sep 2012 15:36:23 +0900
Message-ID: <2689722.93BQTh4lSC@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1347517377.7471.23.camel@lappyti>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <1464760.6eqxJ2IzZ2@percival> <1347517377.7471.23.camel@lappyti>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> * PGP Signed by an unknown key
> 
> On Thu, 2012-09-13 at 15:08 +0900, Alex Courbot wrote:
> 
> > On Thursday 13 September 2012 13:45:39 Tomi Valkeinen wrote:
> > 
> > > > Old Signed by an unknown key
> > > 
> > > 
> > > On Wed, 2012-09-12 at 18:57 +0900, Alexandre Courbot wrote:
> > > 
> > > 
> > > > Some device drivers (panel backlights especially) need to follow
> > > > precise
> > > > sequences for powering on and off, involving gpios, regulators, PWMs
> > > > with a precise powering order and delays to respect between each
> > > > steps.
> > > > These sequences are board-specific, and do not belong to a particular
> > > > driver - therefore they have been performed by board-specific hook
> > > > functions to far.
> > > 
> > > 
> > > 
> > > The sequences are not board-specific, they are device (backlight, etc.)
> > > specific. The sequences have been handled in board-specific hook
> > > functions so far because there hasn't been proper drivers for the
> > > devices.
> > > 
> > > If I were to take the same panel (and backlight) you have and install
> > > it
> > > on my board, I would need the same power sequence.
> > 
> > 
> > You could also have power sequences that control a set of GPIOs for an 
> > external interface (and would then be more board-specific), but you are
> > right 
> 
> What do you mean with "external interface"?

Any crazy circuit design that would make the regular power sequence not usable 
on a specific board. Sorry, I don't have any concrete example in mind, the 
above is just speculation.

> But it's true that there can always be interesting board specific
> hardware designs, and they truly are board specific. In my experience
> these are quite rare, though, but perhaps not so rare that we wouldn't
> need to care about them.
> 
> However, I fear these board specific things may be quite a bit anything,
> so it may well be pwm, gpios and regulators are not enough for them. For
> example, there could be an FPGA on the board which requires some
> configuration to accomplish the task at hand. It could be rather
> difficult to handle it with a generic power sequence.

Right. Note that this framework is supposed to be extended - I would like to 
at least add regulator voltage setting, and maybe even support for clocks and 
pinmux (but that might be out of place).

> So I guess what I'm saying is that mostly these issues are device
> specific, and when they are not, they may be rather complex/strange and
> require c code.

You're definitely right about the powering issue being a device issue 99% of 
the time. For the rest I do not have enough insight to emit an opinion.

Alex.

