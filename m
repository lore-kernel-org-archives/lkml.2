Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1JCMaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:30:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50965 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JCMaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:30:15 -0400
MIME-Version: 1.0
In-Reply-To: <20111003121655.GB3731@opensource.wolfsonmicro.com>
References: <20110927181420.GQ4289@opensource.wolfsonmicro.com>
	<CAMLZHHSuoeAJ-AC9daxb83+EANV=YGK-aiYpQ_j2wFiyQa5ytw@mail.gmail.com>
	<20110927182636.GR4289@opensource.wolfsonmicro.com>
	<CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
	<20110927183832.GS4289@opensource.wolfsonmicro.com>
	<CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
	<20110928123154.GG3279@opensource.wolfsonmicro.com>
	<CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
	<20111003102846.GA23811@sirena.org.uk>
	<CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
	<20111003121655.GB3731@opensource.wolfsonmicro.com>
Date: Mon, 3 Oct 2011 13:30:15 +0100
X-Google-Sender-Auth: 2qXXr6hVgLZdoUoiUyXWyTWI-0k
Message-ID: <CAMLZHHS+fFzuWtwOwt-g2y38g93uaZFyUGsooZyYLMT=mdWQFQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
From: Daniel Drake <dsd@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 1:16 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> It seems to me like either the IP block is heavily dependant on the core
> and shouldn't be split out in the device tree at all (but should instead
> be part of the core node) or the IP block is very isolated from the core
> (in which case we should just be able to instantiate the device from the
> device tree without using explict code in the core driver).
>
> This all feels like there's some abstraction violation going on.

I guess it is a matter of opinion. To me, the abstraction is sensible
and representative of the hardware.

The gpio controller (and several other components) are abstracted at
the hardware level behind an ISA bridge.
In the device tree, we have the ISA bridge represented as /pci/isa.

Then we have various child nodes of that ISA bridge, such as the gpio
controller at /pci/isa/gpios or the timer controller at /pci/isa/timer

This also matches the way that the hardware is described by VIA in the
specs, and it matches the way that Linux has its own device hierachy
laid out (i.e. the ISA bridge driven by the mfd driver, which then
spawns off a child device for the GPIO controller).

It would not be possible to fold all of the isa bridge child
components into the same device tree node without dealing with various
namespace collisions.

Grant, could we have your opinion on whether this is a good
abstraction or not? and generally how we go forward.

Thanks,
Daniel
