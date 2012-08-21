Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2HUIUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:20:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2361 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2HUIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:20:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Aug 2012 01:14:29 -0700
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
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Date: Tue, 21 Aug 2012 17:22:12 +0900
Message-ID: <1562509.b0FYTUZ1D8@percival>
Organization: NVIDIA
User-Agent: KMail/4.9 (Linux/3.4.9-1-ARCH; KDE/4.9.0; x86_64; ; )
In-Reply-To: <1345535069.4085.7.camel@deskari>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1345097337-24170-2-git-send-email-acourbot@nvidia.com> <1345535069.4085.7.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Tuesday 21 August 2012 15:44:29 Tomi Valkeinen wrote:
> > +Problem
> > +-------
> > +One very common board-dependent code is the out-of-driver code that is
> > used to +turn a device on or off. For instance, SoC boards very commonly
> > use a GPIO +(abstracted to a regulator or not) to control the power
> > supply of a backlight, +disabling it when the backlight is not used in
> > order to save power. The GPIO +that should be used, however, as well as
> > the exact power sequence that may +also involve other resources, is
> > board-dependent and thus unknown of the driver. +
> > +This was previously addressed by having hooks in the device's platform
> > data that +are called whenever the state of the device might reflect a
> > power change. This +approach, however, introduces board-dependant code
> > into the kernel and is not +compatible with the device tree.
> 
> I've been having the same problems on OMAP display related code, but the
> problem has always been fixable by just having the driver to use a
> common framework to do the job (a framework which may not have existed
> at the time). The problems have never been board specific in the end,
> but device specific.
> 
> Can you describe your particular HW problem a bit more? In the backlight
> case, what exactly requires the delays and the sequence you show in the
> example to enable/disable the backlight?

In the example, the sequence (including delays) is clearly stated by the 
backlight specification, which is part of the panel specification. The backlight 
uses a PWM, which makes it suitable to use the generic PWM backlight driver, 
but how to turn the backlight on and off is very backlight specific. The power 
sequences allow to replace the board-specific backlight callbacks by sequences 
in the DT.

On the other hand, I saw your discussion with Laurent about the panel 
framework, and I wonder how this would fit into it. Backlights are typically 
embedded within panels. Power sequences are a good way to deal with the 
absence of specific drivers for every panels, since they allow to tailor the 
behavior of generic drivers to fit particular needs. But if every panel comes 
with its own driver (which would define the backlight device using the most 
appropriate driver), then it could just as well perform its backlight's 
sequences via regular callbacks. In this particular case, there would be no 
need for power sequences.

Power sequences are supposed to go beyond backlight drivers and support all 
sort of devices (I have heard that it could be useful for modems as well), but 
I wonder how relevant they are when there is a proper driver for a device. I 
hate to question my own work but now I cannot help but think that a proper 
driver could do the same job. So what are we trying to achieve with power 
sequences? Are we trying to avoid a drivers' explosion by keeping some of the 
specifics out of them? Which approach would be preferable? Are there cases 
where a dedicated driver could not replace power sequences?

Alex.

