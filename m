Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2IRVET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 17:04:19 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52228 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2IRVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 17:04:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120918205248.GZ12245@n2100.arm.linux.org.uk>
References: <1347615189-27052-1-git-send-email-vinod.koul@linux.intel.com>
	<20120914094155.GC12245@n2100.arm.linux.org.uk>
	<1347619868.1943.113.camel@vkoul-udesk3>
	<20120914111842.GD12245@n2100.arm.linux.org.uk>
	<1347853223.1943.136.camel@vkoul-udesk3>
	<20120917083654.GO12245@n2100.arm.linux.org.uk>
	<1347875429.1943.141.camel@vkoul-udesk3>
	<20120917215753.GS12245@n2100.arm.linux.org.uk>
	<1347938307.1943.166.camel@vkoul-udesk3>
	<CACRpkdaBiJXowtWm=yTV4_7=6P=SFuVuZo8+icQfE0EN87A23g@mail.gmail.com>
	<20120918205248.GZ12245@n2100.arm.linux.org.uk>
Date: Tue, 18 Sep 2012 23:04:13 +0200
Message-ID: <CACRpkdZHN4yw51j0-83a5Z+hoPDL2yZ11Vcx+tYHeyJMrDgVLw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dmanegine slave map api's
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Hunter <jon-hunter@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Benoit Cousson <b-cousson@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
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

On Tue, Sep 18, 2012 at 10:52 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> There's a clue in that paragraph about how the DMA engine TX descriptors
> _should_ be handled.  "hold a reference" is the clue.  Or another way to
> say it, a kref should be embedded in the structure, providing us with
> proper reference counting - and descriptors should only be 'freed'
> (whether that means actually freeing them or placing them into a free
> list) when the last reference is dropped.  That's _much_ better to
> understand than this DMA_CTRL_ACK business...

This indeed sounds like a more robust approach by far.
Why didn't we do that from the beginning ...

Yours,
Linus Walleij
