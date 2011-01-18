Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1ARJZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:25:38 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50777 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab1ARJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:25:37 -0500
Date: Tue, 18 Jan 2011 18:23:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110118092319.GB18525@linux-sh.org>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo> <20110111101636.GF26617@pengutronix.de> <201101111827.12291.jeremy.kerr@canonical.com> <20110111112240.GQ12078@pengutronix.de> <20110118084445.GL2122@linux-sh.org> <20110118092128.GO9041@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118092128.GO9041@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 10:21:28AM +0100, Sascha Hauer wrote:
> On Tue, Jan 18, 2011 at 05:44:45PM +0900, Paul Mundt wrote:
> > Do you guys even bother to grep the kernel for users of the API before
> > coming up with arbitrary policy?
> 
> Actually I did bother to grep the kernel and I came up with these
> results:
> 
> drivers/video/omap2/dss/dss.c:219:      dpll4_ck_rate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
> drivers/video/omap2/dss/dss.c:312:      prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
> drivers/video/omap2/dss/dss.c:325:              prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
> drivers/video/omap2/dss/dss.c:344:              prate = clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
> drivers/video/omap2/dss/dss.c:359:              return clk_get_rate(clk_get_parent(dss.dpll4_m4_ck));
> drivers/video/sh_mobile_hdmi.c:716:     else if (clk_get_parent(hdmi->hdmi_clk))
> drivers/video/sh_mobile_hdmi.c:717:             *parent_rate = clk_get_rate(clk_get_parent(hdmi->hdmi_clk));
> drivers/video/sh_mobile_hdmi.c:1089:    if (parent_rate && clk_get_parent(hdmi->hdmi_clk)) {
> drivers/video/sh_mobile_hdmi.c:1090:            ret = clk_set_rate(clk_get_parent(hdmi->hdmi_clk), parent_rate);
> drivers/usb/host/ehci-omap.c:405:                       ret = clk_set_parent(omap->utmi_p1_fck,
> drivers/usb/host/ehci-omap.c:435:                       ret = clk_set_parent(omap->utmi_p2_fck,
> 
Then I recommend you grep harder. There are more drivers than the ones
that simply live in drivers/.

> > There are plenty of cases where clocks are allocated dynamically by
> > driver code that in turn can be set up as a parent for other dynamically
> > allocated clocks. This has not a damn thing to do with platform code and
> > everything to do with the clock circuitry of the device or IP block in
> > question.
> 
> The majority of users do not use clk_{get,set}_parent at all. And it's
> really questionable whether drivers should know anything about the
> layout of the clock tree. I'm pretty sure that these are the code pieces
> where there will be a if_soc_rev(x) around it once the next incarnation
> of a SoC comes out.
> 
It's not questionable in the least, you're simply dealing with cases
where you personally haven't had a need to do so and are attempting to
project that as a policy. I'm getting pretty tired of this.

We have many IP blocks that can use external clocks or drive their own
clock circuitry, in which case the internal clocks are parented by a
parent clock that is likewise also dynamically created. Your lack of
imagination is really not my concern, and again, this has nothing to do
with the SoC.
