Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1GKLMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:12:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41012 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1GKLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:12:10 -0400
Date: Mon, 11 Jul 2011 12:11:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Grant Likely <grant@secretlab.ca>,
        linux-sh@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] clk: Support multiple instances of the same clock
	provider
Message-ID: <20110711111153.GH3239@n2100.arm.linux.org.uk>
References: <20110711025344.GA27497@opensource.wolfsonmicro.com> <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1310352837-4277-5-git-send-email-broonie@opensource.wolfsonmicro.com> <20110711093439.GB3239@n2100.arm.linux.org.uk> <20110711105342.GE5092@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711105342.GE5092@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 07:53:45PM +0900, Mark Brown wrote:
> We do need some way to have some idea which clocks we're talking about,
> and for off-SoC stuff passing around struct clk pointers is rather
> painful.  At some point some bit of code is going to have to get hold of
> the actual struct clk and then map it onto the devices using it.

As I haven't seen any of this "passing around struct clk pointers" crap
recently, I can only guess at what you're saying.  I thought all that
had been solved with _proper_ use of clkdev.

clkdev can provide you with a struct clk for _any_ device in the system
where its name is known at build time.

For devices where the name is not known at build time, a new cl_lookup
entry can be created at runtime with clkdev_alloc() or clk_add_alias(),
and dropped with clkdev_drop().

The problem comes when you aren't able to hook into a subsystem which
creates an unstable device name (eg, USB).  I suspect that's also a
problem for DT too because there has to be some way to go from a struct
device to something stable.
