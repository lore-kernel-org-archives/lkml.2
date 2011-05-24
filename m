Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1EXG0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:26:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36917 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1EXG03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:26:29 -0400
Date: Tue, 24 May 2011 08:26:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Colin Cross <ccross@google.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110524062620.GA22096@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.325655.313573683829.0.gpush@pororo>
 <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:22:33 up 3 days, 20:01, 14 users,  load average: 0.32, 0.39, 0.41
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 04:12:24PM -0700, Colin Cross wrote:
> >
> >   tglx's plan is to create a separate struct clk_hwdata, which contains a
> >   union of base data structures for common clocks: div, mux, gate, etc. The
> >   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
> >   hwdata fields are handled within the core clock code. This means less
> >   encapsulation of clock implementation logic, but more coverage of
> >   clock basics through the core code.
> 
> I don't think they should be a union, I think there should be 3
> separate private datas, and three sets of clock ops, for the three
> different types of clock blocks: rate changers (dividers and plls),
> muxes, and gates.  These blocks are very often combined - a device
> clock often has a mux and a divider, and clk_set_parent and
> clk_set_rate on the same struct clk both need to work.

The idea is to being able to propagate functions to the parent. It's
very convenient for the implementation of clocks when they only
implement either a divider, a mux or a gate. Combining all of these
into a single clock leads to complicated clock trees and many different
clocks where you can't factor out the common stuff.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
