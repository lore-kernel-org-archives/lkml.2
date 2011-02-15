Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1BOGS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:18:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59671 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1BOGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:18:55 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
Date: Tue, 15 Feb 2011 14:18:37 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, Dima Zavin <dmitriyz@google.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <1297233693.242725.820672531799.2.gpush@pororo> <201102150941.00668.jeremy.kerr@canonical.com> <4D5A063F.1010102@codeaurora.org>
In-Reply-To: <4D5A063F.1010102@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102151418.37780.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Saravana,

> >> A fixed clock may still have other operations such as enable/disable.
> > 
> > Then it's not a fixed clock; I'd prefer this to be a separate type, as
> > it's now hardware dependent.
> 
> I'm confused. If a clock's rate can't be changed and it can't be enabled
> or disabled, then what's the point of representing that clock
> signal/line as a clock in the driver.

Because the drivers using this clock don't know that it's a fixed clock.

For example, a uart needs to know the rate of its clock source, so that it can 
set its internal divisors to get a valid baud rate. The uart driver will query  
the input rate using clk_get_rate(). The driver still needs to call 
clk_enable/clk_prepare/etc, because on some systems it may have a switchable 
clock.

Cheers,


Jeremy

