Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1BAUnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:43:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45593 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab1BAUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:43:49 -0500
Date: Tue, 1 Feb 2011 21:43:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110201204330.GJ1147@pengutronix.de>
References: <20110201131512.GH31216@n2100.arm.linux.org.uk>
 <20110201141837.GA1147@pengutronix.de>
 <20110201143932.GK31216@n2100.arm.linux.org.uk>
 <20110201151846.GD1147@pengutronix.de>
 <20110201152458.GP31216@n2100.arm.linux.org.uk>
 <20110201155344.GF1147@pengutronix.de>
 <20110201170637.GR31216@n2100.arm.linux.org.uk>
 <20110201193201.GH1147@pengutronix.de>
 <20110201195604.GS31216@n2100.arm.linux.org.uk>
 <4D486B59.6010106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D486B59.6010106@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 12:21:45PM -0800, Saravana Kannan wrote:
> If the driver is calling clk_prepare() right next to clk_enable()
> knowing it's been already prepared and will hence be "atomic" (this
> is actually not true), then by your description, it's pointless to
> call clk_prepare().
Well not completely, as it increases the reference count.  The advantage
would be that clk_enable counts addionally as prepare, so it would be
impossible to unprepare an enabled clock.  And the other way round an
unprepared clock would never be enabled.
 
> If you want the driver to call clk_prepare() in atomic context
> because it will be atomic in most cases -- well, that's wrong. It's
> either atomic or is NOT atomic. There is no in between. If a call is
> NOT atomic, it can't be called in atomic context. Long story short,
> if you expect clk_prepare() to be atomic under any circumstance, it
> beats the point of introducing clk_prepare().
Well, with my suggestion it's atomic when certain precondions are given.
IMHO that's better than "atomic in most cases" because the caller can
assert that everything goes smooth.
These preconditions are asserted when the driver writer is careful
enough to stick to the API.

Either my idea is bad or I'm unable to sell it appropriately.  Be it as
it is, I will stop to make a case for it.

Best regards and thanks for your try,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
