Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KSEbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 23:31:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44945 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2KSEbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 23:31:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <20121117135435.GA13479@lunn.ch>
CC: Andrew Lunn <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
 <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
 <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
 <20121117082602.GF24569@lunn.ch> <50A75BB4.4070003@free-electrons.com>
 <20121117135435.GA13479@lunn.ch>
Message-ID: <20121119043034.21126.92888@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control provider
 for DT
Date: Sun, 18 Nov 2012 20:30:34 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lunn (2012-11-17 05:54:35)
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
> 

CLK_IGNORE_UNUSED is the flag you want for this situation.

Regards,
Mike

>      Andrew
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
