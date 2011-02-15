Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1BOCAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:00:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43293 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1BOCAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:00:44 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC, PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
Date: Tue, 15 Feb 2011 10:00:28 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Richard Zhao <richard.zhao@freescale.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <1297233693.241680.897691111624.0.gpush@pororo> <1297233693.243373.411051105619.3.gpush@pororo> <20110210093756.GA24710@b20223-02.ap.freescale.net>
In-Reply-To: <20110210093756.GA24710@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151000.29385.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

> >  void clk_unprepare(struct clk *clk)
> >  {
> > 
> > +	WARN_ON(clk->enable_count != 0);
> > +
> 
> Other drivers may be using the clock and increased the enable_count.
> This check may be moved to where we actually do unprepare.

Of course, thanks. Will update the series.


Jeremy
