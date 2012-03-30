Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817Ab2C3STw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:19:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52649 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab2C3STu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:19:50 -0400
Date: Fri, 30 Mar 2012 20:19:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Anatolij Gustschin <agust@denx.de>,
        Andreas Koensgen <ajk@comnets.uni-bremen.de>,
        Andrew Lunn <andrew@lunn.ch>, Andrew Victor <linux@maxim.org.za>,
        Arnd Bergmann <arnd@arndb.de>, Barry Song <baohua.song@csr.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, cbe-oss-dev@lists.ozlabs.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Brown <davidb@codeaurora.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Eric Miao <eric.y.miao@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Grant@igel.home
Subject: Re: [PATCH 00/17] mark const init data with __initconst instead of
 __initdata
Message-ID: <20120330181936.GU15647@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
 <20120330095859.GT15647@pengutronix.de>
 <m2bone7215.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m2bone7215.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On Fri, Mar 30, 2012 at 01:37:26PM +0200, Andreas Schwab wrote:
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> 
> > After a question by Shawn Guo I noticed that my command to do the changes
> > was to lax and changed things that must not be changed (at least not
> > with further care). Affected are lines like:
> >
> > 	static const char *at91_dt_board_compat[] __initconst = {
> >
> > While at91_dt_board_compat[0] is const, at91_dt_board_compat is not.
> 
> Though it looks like at91_dt_board_compat should really be const (it is
> assigned to a const pointer, likewise for all other uses of struct
> machine_desc.dt_compat).
Yeah, still for this series I will revert to static const char
*at91_dt_board_compat[] __initdata to only have a single logical change.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
