Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1BAOBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:01:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34086 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab1BAOBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:01:02 -0500
Date: Tue, 1 Feb 2011 15:00:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201140024.GZ1147@pengutronix.de>
References: <201102011711.31258.jeremy.kerr@canonical.com>
 <20110201105449.GY1147@pengutronix.de>
 <AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:05:56PM +0900, Jassi Brar wrote:
> 2011/2/1 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> 
> .....
> 
> > Do you plan to handle the case that clk_enable is called while prepare
> > isn't completed (considering the special case "not called at all")?
> > Maybe BUG_ON(clk->ops->prepare && !clk->prepare_count)?
> Sounds better than the second option.
> 
> > Alternatively don't force the sleep in clk_prepare (e.g. by protecting
> > prepare_count by a spinlock (probably enable_lock)) and call clk_prepare
> > before calling clk->ops->enable?
> That might result in a driver working on some platforms(those have
> atomic clk_prepare)
> and not on others(those have sleeping).
The first option has the same result.  E.g. on some platforms
clk->ops->prepare might be NULL, on others it's not.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
