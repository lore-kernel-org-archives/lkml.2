Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1GKKx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 06:53:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48248 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754425Ab1GKKx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 06:53:56 -0400
Date: Mon, 11 Jul 2011 19:53:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] clk: Support multiple instances of the same clock
 provider
Message-ID: <20110711105342.GE5092@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110711093439.GB3239@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711093439.GB3239@n2100.arm.linux.org.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:34:39AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 11, 2011 at 11:53:56AM +0900, Mark Brown wrote:

> > +	/* Since we currently match clock providers on a purely string
> > +	 * based method add a prefix based on the device name if a
> > +	 * device is provided.  When we have support for device tree

> This "clk consolidation" is really idiotic.  The clk matching mechanism
> should have _nothing_ to do with the rest of the clk API, especially the
> consolidation effort.

It's not touching clkdev, the comment is somewhat misleading and is
mostly based on me thinking about how we'd deploy off-SoC clocks.
There's also the diagnostic issues Sacha mentioned, if we don't keep
some source information handy it's hard to tell what clock logging is
talking about.

> It should not matter whether clkdev is used, or an alternative method
> to specify this stuff via DT.  Keep the clk_get()/clk_put() _separate_
> from the consolidation of the rest.

We do need some way to have some idea which clocks we're talking about,
and for off-SoC stuff passing around struct clk pointers is rather
painful.  At some point some bit of code is going to have to get hold of
the actual struct clk and then map it onto the devices using it.

For device tree we should be able to do that fairly painlessly with just
the struct devices, without device tree you either have to have the
structs handy or use names.  At the minute the infrastructure is
somewhat lacking here.
