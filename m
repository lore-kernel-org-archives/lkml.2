Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2F0Q3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:29:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39926 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2F0Q3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:29:00 -0400
Date: Wed, 27 Jun 2012 18:28:51 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rajendra Nayak <rnayak@ti.com>
Cc: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2] clk: Add support for rate table based dividers
Message-ID: <20120627162851.GT1623@pengutronix.de>
References: <1340794893-20869-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340794893-20869-1-git-send-email-rnayak@ti.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:23:54 up 4 days,  7:35, 46 users,  load average: 0.92, 1.05, 1.03
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 04:31:33PM +0530, Rajendra Nayak wrote:
> Some divider clks do not have any obvious relationship
> between the divider and the value programmed in the
> register. For instance, say a value of 1 could signify divide
> by 6 and a value of 2 could signify divide by 4 etc.
> Also there are dividers where not all values possible
> based on the bitfield width are valid. For instance
> a 3 bit wide bitfield can be used to program a value
> from 0 to 7. However its possible that only 0 to 4
> are valid values.
> 
> All these cases need the platform code to pass a simple
> table of divider/value tuple, so the framework knows
> the exact value to be written based on the divider
> calculation and can also do better error checking.
> 
> This patch adds support for such rate table based
> dividers.
> 
> Also since this means adding a new parameter to the
> clk_register_divider(), update all existing users of
> it.

I'm not sure whether we should overload the divider code with another
type of divider. Maybe it would be better to add a new
clk-divider-table.c for this? Just an idea, the result may or may not be
better.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
