Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2IRMU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:20:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50626 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2IRMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <1347938307.1943.166.camel@vkoul-udesk3>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com>
	<20120914094155.GC12245@n2100.arm.linux.org.uk>
	<1347619868.1943.113.camel@vkoul-udesk3>
	<20120914111842.GD12245@n2100.arm.linux.org.uk>
	<1347853223.1943.136.camel@vkoul-udesk3>
	<20120917083654.GO12245@n2100.arm.linux.org.uk>
	<1347875429.1943.141.camel@vkoul-udesk3>
	<20120917215753.GS12245@n2100.arm.linux.org.uk>
	<1347938307.1943.166.camel@vkoul-udesk3>
Date: Tue, 18 Sep 2012 14:20:53 +0200
Message-ID: <CACRpkdaBiJXowtWm=yTV4_7=6P=SFuVuZo8+icQfE0EN87A23g@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Benoit Cousson <b-cousson@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Per Forlin <per.forlin@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 5:18 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> On Mon, 2012-09-17 at 22:57 +0100, Russell King - ARM Linux wrote:
>>
>> Except that we expose one 'channel' per mux setting, so as far as DMA
>> engine goes, the mux number _is_ the channel number - which is the same
>> approach taken by the PL08x and sa11x0 DMA engine drivers.  It is the
>> only sane approach to dealing with N hardware channels vs >>N clients.
> Sure that makes things easy in dmaengine code.
>
> So we allocate channel number given by slave id (if set) or first free
> channel. This would also mean people need to update their drivers to use
> virtual channel which indeed is a good idea :)

Yeah, then just to complicate the world the DMA40 has "logical channels",
which is basically hardware-virtual channels multiplexed over physical
channels (so the hardware does some round-robin and queueing).

So we're actually a bit like:
clients = logical HW channels > physical channels
...

And since using logical channels has a performance impact we
have hacks in place to lock down a physical channel for a certain
client like MMC.

But we're probably the odd exception here so nevermind.
One day we may test to rip out the logical channel handling and
use Russell's virtual channel lib to run the show as an experiment.

Yours,
Linus Walleij
