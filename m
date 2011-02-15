Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1BOBlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:41:18 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38211 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1BOBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:41:17 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH 2/3] clk: Generic support for fixed-rate clocks
Date: Tue, 15 Feb 2011 09:41:00 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Ryan Mallon <ryan@bluewatersys.com>,
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
References: <1297233693.242725.820672531799.2.gpush@pororo> <4D54738C.80900@bluewatersys.com>
In-Reply-To: <4D54738C.80900@bluewatersys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102150941.00668.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> A fixed clock may still have other operations such as enable/disable.

Then it's not a fixed clock; I'd prefer this to be a separate type, as it's 
now hardware dependent.

> Maybe do something like this instead:
> #define INIT_CLK_FIXED(name, ops, r) { 		\
> 	.clk = INIT_CLK(name.clk, ops, rate), 	\
> 	.clk.ops.get_rate = clk_fixed_get_rate, \
> 	.rate = (r),				\
> }
> 
> That's untested though. I'm not sure if you can reliably assign
> something twice in a struct initialiser?

also, clk->ops is a const.

Cheers,


Jeremy
