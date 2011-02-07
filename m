Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1BGOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:25:05 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49716 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1BGOZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:25:03 -0500
Date: Mon, 7 Feb 2011 09:24:58 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Jeremy Kerr <jeremy.kerr@canonical.com>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare
 semantics
In-Reply-To: <201102071608.42855.jeremy.kerr@canonical.com>
Message-ID: <alpine.LFD.2.00.1102070908120.14920@xanadu.home>
References: <201102011711.31258.jeremy.kerr@canonical.com> <1297058877.800990.238556019385.3.gpush@pororo> <20110207080555.GC27982@pengutronix.de> <201102071608.42855.jeremy.kerr@canonical.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Jeremy Kerr wrote:

> Hi Uwe,
> 
> > This implies the warning is only issued on clocks that have a prepare
> > callback.  If we want to enforce the new API the warning here shouldn't
> > depend on clk->ops->prepare.  (clk_prepare and clk_unprepare need to
> > be changed then to adapt the prepare_count even in the absence of
> > clk->ops->prepare.)
> 
> Yeah, it's a decision about either adding a small cost to all clk_prepare()s 
> (ie, adding cost when there is no prepare callback), or checking for the 
> correct prepare/enable semantics for all clocks (even when it doesn't matter 
> for that particular clock). I chose the first as more important, but happy to 
> go either way here.

The prepare method being called from non-atomic context cannot be 
considered to be in a speed critical path.  Most of the time, this is 
going to be called on driver initialization or the like, and that's a 
relatively rare event. Therefore this really small cost to clk_prepare() 
is definitively worth it to help proper usage of the API.  If this ever 
becomes a problem then this could be confined to some CONFIG_CLK_DEBUG 
or the like.  But when introducing a new API it is best to be more 
strict to help people get its usage right (without going overboard with 
it of course).


Nicolas
