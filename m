Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1AKLWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:22:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55071 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1AKLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:22:44 -0500
Date: Tue, 11 Jan 2011 12:22:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110111112240.GQ12078@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <1294199462.348449.192344022926.1.gpush@pororo>
 <20110111101636.GF26617@pengutronix.de>
 <201101111827.12291.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111827.12291.jeremy.kerr@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:14:53 up 7 days, 20:22, 49 users,  load average: 0.16, 0.38,
 0.40
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 06:27:11PM +0800, Jeremy Kerr wrote:
> Hi Sascha,
>  
> > The i.MX clk implementation disables the old parent if clk is enabled
> > and enables the new parent if clk is enabled (modulo bugs). Shouldn't
> > we do this here aswell?
> 
> Sounds reasonable, yes.
> 
> > I thought about returning -EBUSY if clk_set_parent is called for an
> > enabled clk, but this way we could never reparent the cpu clock which I
> > think is done in the Freescale BSP for power saving.
> 
> I think that the possibility for changing the parent really depends on the 
> implementation; in some cases we may want to disallow it, in others it might 
> be fine.
> 
> Related: do we really need globally-accessible clk_{get,set}_parent in the clk 
> API? For cases where we need to set the parent, we probably need details about 
> the platform clock configuration (eg, which clocks are possible parents). In 
> this case, we could just call into the clock driver directly.

I agree that drivers have no business calling clk_{get,set}_parent, this
is purely platform specific.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
