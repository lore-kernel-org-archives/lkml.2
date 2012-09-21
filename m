Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab2IUAbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:31:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38416 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab2IUAbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:31:12 -0400
Date: Thu, 20 Sep 2012 17:20:37 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: dwmw2@infradead.org, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: ac_draw used before set
Message-ID: <20120921002037.GA31075@lizard>
References: <505A0293.4070708@yahoo.com>
 <20120920213232.GA18223@lizard>
 <505BB1E6.3010502@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <505BB1E6.3010502@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:16:38AM +0100, Paul Parsons wrote:
> >>When I reboot my iPAQ hx4700 in its cradle, the battery will not begin
> >>to charge even though the AC supply is connected. Charging will start
> >>only after the PDA power driver is tickled by some other power event,
> >>such as reseating the iPAQ in its cradle or connecting the USB cable.
> >>
> >>The problem lies in pda_power_probe(), where ac_draw is used by the call
> >>to update_charger() before being set by the call to regulator_get().
> >>
> >>Moving the regulator_get() call to before the update_charger() call
> >>fixes the problem.
> >>
> >>Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> >>Cc: Philipp Zabel <philipp.zabel@gmail.com>
> >>---
> >
> >Great to see that someone is still using hx4700. :-)
> >
> >Thanks for the patch, it is merged now!
> 
> I am having second thoughts about the goto ac_draw_failed I added.
> This will cause pda_power_probe() to fail if regulator_get() fails.
> However the way ac_draw is used - always after a check for NULL -
> suggests that a failed call to regulator_get() was not fatal.
> 
> I am happy to submit another patch to remove the goto and label.

Sure thing, just send another patch on top.

Thanks!
Anton.
