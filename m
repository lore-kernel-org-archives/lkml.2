Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab1GDRQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:16:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34899 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753816Ab1GDRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:16:49 -0400
Date: Mon, 4 Jul 2011 10:16:37 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110704171634.GD28726@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
 <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
 <20110630052808.GA796@opensource.wolfsonmicro.com>
 <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
 <20110630055719.GA930@opensource.wolfsonmicro.com>
 <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
 <20110630155634.GE3249@opensource.wolfsonmicro.com>
 <BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikPOj6N=TQ=tayx7hTXcLAJd5zf7w@mail.gmail.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 09:43:31AM +0900, MyungJoo Ham wrote:
> On Fri, Jul 1, 2011 at 12:56 AM, Mark Brown

> > This looks like charger specific configuration which should be done by
> > the charger driver rather than by directly working with the IRQs?

> Well, the issue is that the charger driver just does not know what to
> do with its own interrupts.

> For example, each board has different regulator setting for DCIN
> depending on the specification of the board (some uses 450mA
> constantly, some uses 450mA and 700mA depending on the connection
> information, which is not known to charger driver, some uses 900mA
> unconditionally, and so on).

That sounds like the charger driver just needs some platform data.

> Sometimes setting the attributes of a charger at its own interrupts
> depends on the status of another charger; when we have USB charger,
> wireless charger, and solar panels, which may be enabled independently
> and have their own device drivers.

My understanding was that one of the goals of the power_supply subsystem
was to support this sort of interaction?  This (and your subsequent
paragraphs) all sounds entirely sensible but it should be being dealt
with at a higher level with the various charger drivers delivering
events into a subsystem or board driver which coordinates them all.  It
seems like the driver should be doing the work of dealing with the
actual interrupts.
