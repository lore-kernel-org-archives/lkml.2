Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2KSPq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:46:26 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:39954 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2KSPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:46:25 -0500
Date: Mon, 19 Nov 2012 16:46:11 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
Message-ID: <20121119164611.2e754b64@skate>
In-Reply-To: <20121117135435.GA13479@lunn.ch>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
	<1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
	<1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
	<20121117082602.GF24569@lunn.ch>
	<50A75BB4.4070003@free-electrons.com>
	<20121117135435.GA13479@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Sat, 17 Nov 2012 14:54:35 +0100, Andrew Lunn wrote:
> > > What is the ddr clock for? Does bad things happen if you turn it off?
> > > Kirkwood has a similar clock, dunit, which i decided not to export,
> > > since when you turn it off, the whole SoC locks up.
> > 
> > Well of course if you code run in DDR then it could be a problem. But
> > I think it could be useful to turn it off when going to suspend, it
> > the DDR can do self-refresh. In this case it should be possible to run
> > the code from SRAM or L2 Cache.
> 
> O.K. Just watch out for the lateinit call in the clock framework.

I don't think there is a problem with the dramclk and the lateinit call
of the clock framework. The dramclk is a fixed factor clock, and the
fixed factor clock driver does not implement the ->disable() operation.
And therefore, the clk_disable_unused() code executed as the lateinit
call will not be able to disable it:

	if (__clk_is_enabled(clk) && clk->ops->disable)
		clk->ops->disable(clk->hw);

So I think we're quite safe with fixed rate clocks and fixed factor
clocks in that no-one can disable them :-)

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
