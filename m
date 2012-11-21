Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2KUKAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:00:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10762 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2KUKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:00:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 21 Nov 2012 02:00:34 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Date: Wed, 21 Nov 2012 19:00:32 +0900
Message-ID: <4275468.QAmZy3xUK6@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50AC956D.7020303@ti.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1699753.ZQsWMHINxd@percival> <50AC956D.7020303@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2012 16:48:45 Tomi Valkeinen wrote:
> If the power-off sequence disables a regulator that was supposed to be
> enabled by the power-on sequence (but wasn't enabled because of an
> error), the regulator_disable is still called when the driver runs the
> power-off sequence, isn't it? Regulator enables and disables are ref
> counted, and the enables should match the disables.

And there collapses my theory.

> > Failures might be better handled if sequences have some "recovery policy"
> > about what to do when they fail, as mentioned in the link above. As you
> > pointed out, the driver might not always know enough about the resources
> > involved to do the right thing.
> 
> Yes, I think such recovery policy would be needed.

Indeed, from your last paragraph this makes even more sense now.

Oh, and I noticed I forgot to reply to this:

> This I didn't understand. Doesn't "<&pwm 2 xyz>" point to a single
> device, no matter where and how many times it's used?

That's true - however when dereferencing the phandle, the underlying framework 
will try to acquire the PWM, which will result in failure if the same resource 
is referenced several times.

One could compare the phandles to avoid this, but in your example you must 
know that for PWMs the "xyz" part is not relevant for comparison.

This makes referencing of resources by name much easier to implement and more 
elegant with respect to frameworks leveraging.

Alex.

