Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1GKLlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:41:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34427 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754801Ab1GKLln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:41:43 -0400
Date: Mon, 11 Jul 2011 20:41:30 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] clk: Support multiple instances of the same clock
 provider
Message-ID: <20110711114127.GI5092@opensource.wolfsonmicro.com>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com>
 <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110711093439.GB3239@n2100.arm.linux.org.uk>
 <20110711105342.GE5092@opensource.wolfsonmicro.com>
 <20110711111153.GH3239@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711111153.GH3239@n2100.arm.linux.org.uk>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:11:53PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 11, 2011 at 07:53:45PM +0900, Mark Brown wrote:
> > We do need some way to have some idea which clocks we're talking about,
> > and for off-SoC stuff passing around struct clk pointers is rather
> > painful.  At some point some bit of code is going to have to get hold of
> > the actual struct clk and then map it onto the devices using it.

> As I haven't seen any of this "passing around struct clk pointers" crap
> recently, I can only guess at what you're saying.  I thought all that
> had been solved with _proper_ use of clkdev.

The problem is getting the data into clkdev in the first place for the
off-SoC devices.

> clkdev can provide you with a struct clk for _any_ device in the system
> where its name is known at build time.

Right, on the consumer side it's all sorted and works really well.  The
trick is on the provider side where you need to have the clock available
to be able to add the mappings for it.

Perhaps I'm just missing something about how this should all work -
actually, the regulator solution probably works fine here.  Pass an
array of mappings into either the driver or the clock subsystem and have
them add the mappings when the provider registers.  Whichever way around
should just be some hooks in the new subsystem.
