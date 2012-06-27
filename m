Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab2F0SGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:06:51 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:37568 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547Ab2F0SGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:06:49 -0400
Date: Wed, 27 Jun 2012 11:06:35 -0700
From: Mike Turquette <mturquette@ti.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rajendra Nayak <rnayak@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2] clk: Add support for rate table based dividers
Message-ID: <20120627180635.GH22766@gmail.com>
References: <1340794893-20869-1-git-send-email-rnayak@ti.com>
 <20120627162851.GT1623@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627162851.GT1623@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120627-18:28, Sascha Hauer wrote:
> On Wed, Jun 27, 2012 at 04:31:33PM +0530, Rajendra Nayak wrote:
> > Some divider clks do not have any obvious relationship
> > between the divider and the value programmed in the
> > register. For instance, say a value of 1 could signify divide
> > by 6 and a value of 2 could signify divide by 4 etc.
> > Also there are dividers where not all values possible
> > based on the bitfield width are valid. For instance
> > a 3 bit wide bitfield can be used to program a value
> > from 0 to 7. However its possible that only 0 to 4
> > are valid values.
> > 
> > All these cases need the platform code to pass a simple
> > table of divider/value tuple, so the framework knows
> > the exact value to be written based on the divider
> > calculation and can also do better error checking.
> > 
> > This patch adds support for such rate table based
> > dividers.
> > 
> > Also since this means adding a new parameter to the
> > clk_register_divider(), update all existing users of
> > it.
> 
> I'm not sure whether we should overload the divider code with another
> type of divider. Maybe it would be better to add a new
> clk-divider-table.c for this? Just an idea, the result may or may not be
> better.
> 

Sascha,

I had the same concerns originally, but the code reuse in clk-divider.c
is pretty good.  Before this patch I have it about 200 lines, most of
which would have to be reproduced for a separate clk-rate-table.c.  So I
think marginally added complexity is OK compared to code duplication
(and duplicate bugfixes, etc).

Rajendra,

After thinking about it a bit more I still think a separate
clk_register_divider_table is needed.  Primarily this would reduce
needless churn in having to update all existing users of
clk_register_divider.  I also think that clearly separating the two
functions will make it a bit easier on folks trying to port their clocks
trees over.

Unless there is a technical reason why having two registration functions
is a bad idea, can you send a V4 with that new registration function?
I'll take it into clk-next.

Thanks,
Mike

> Sascha
> 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
