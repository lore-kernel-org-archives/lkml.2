Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2G3RZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:25:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45732 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab2G3RZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:25:41 -0400
Date: Mon, 30 Jul 2012 18:25:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3/3] regmap: enhance regmap-irq to handle 1 IRQ feeding n
 chips
Message-ID: <20120730172538.GM4468@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
 <1343415716-27134-3-git-send-email-swarren@wwwdotorg.org>
 <20120729203636.GE4384@opensource.wolfsonmicro.com>
 <5016BD94.4080302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016BD94.4080302@wwwdotorg.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:00:04AM -0600, Stephen Warren wrote:
> On 07/29/2012 02:36 PM, Mark Brown wrote:
> > On Fri, Jul 27, 2012 at 01:01:56PM -0600, Stephen Warren wrote:

> I had implemented this in regmap since you'd specifically mentioned
> doing that. If I convert the code not to use separate IRQ domains for

I think what I'd said was that we should factor it out rather than that
it should be specifically done in regmap.

> this, would that be acceptable?

Probably.

> >> +	ret = pm_runtime_get_sync(d->dev);
> >> +	if (ret < 0) {

> > This is conditional in the core regmap runtime PM support, it may be
> > actively harmful if the device doesn't need it.

> Hmmm. I actually don't see any pm_*() usage in regmap right now. I
> assume this /is/ needed to convert arizona.c, since it's making these
> calls today. I don't need it for max8907.c. Should I add another flag to
> regmap_add_irq_chips() indicating whether this is needed, or ...?

It's not in -next yet due to the merge window.  There's already a flag
for it in the irq chip data.
