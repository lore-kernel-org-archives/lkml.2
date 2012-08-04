Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2HDNFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 09:05:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35736 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2HDNEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 09:04:48 -0400
Date: Sat, 4 Aug 2012 11:54:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Anthony Olech <anthony.olech@diasemi.com>,
        Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Message-ID: <20120804105424.GB10523@opensource.wolfsonmicro.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208020805.q72858Yj003147@latitude.olech.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 07:05:15PM +0100, Anthony Olech wrote:

> if the irq_base is set to -1 when calling regmap_add_irq_chip()
> then allow the IRQ to be mapped even if the allocated irq_base
> is actually zero.

> This restores the behaviour seen in v3.4, and I assume that the
> tidy-ups just made in v3.5 INADVERTENTLY introduce this change
> in behaviour.

Please pay MORE attention to the changelog - obviously there's no
problem mapping automatically allocated IRQs, there's only any effect if
they happen to GET allocated at zero.

The only real issue I see with the current code is that if the user
explicitly wants to statically allocate an IRQ range at zero they can't.
The current intended behaviour is that we use a linear domain unless a
positive IRQ base is specified, though we're not quite doing that right
now as a transitional measure until drivers are updated.

The current da9052 driver usage seems to have quite a few problems, I do
recall having to fix some problems that make me doubt if it ever worked
well.  Looking at the code now I see it's using hard coded references to
absolute IRQ numbers which is an issue...  It should be being converted
to use regmap_irq_get_virq().
