Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2G3Ri3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:38:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60241 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704Ab2G3RiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:38:25 -0400
Date: Mon, 30 Jul 2012 18:38:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 2/3] regmap: implement irq chip suspend/resume operations
Message-ID: <20120730173822.GN4468@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
 <1343415716-27134-2-git-send-email-swarren@wwwdotorg.org>
 <20120729210410.GM4384@opensource.wolfsonmicro.com>
 <5016C006.80008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016C006.80008@wwwdotorg.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:10:30AM -0600, Stephen Warren wrote:

> hence exit sleep. If we are to port that code into the regmap-irq core,
> it seems to make sense to have enable_base==wake_base, since the same
> register truly is being used for both enable/wakeup-enable, just
> time-multiplexed.

This would mean that we have to go round every single driver that
doesn't have physical wake support and add a setting for the wake
registers (which seems pointless given that the core can just as well
figure this out from the fact that it's not had any wake registers
specified) and we then have to add special cases for this in the core
code.  This doesn't seem like great API design, it's not conveneint for
either side of the interface and it's error prone.

> Or, perhaps the IRQ core already disables all non-wake interrupts for
> us, so the driver doesn't have to do this, and we can just drop that
> code completely?

IIRC it does actually do this, I'd need to check though.
