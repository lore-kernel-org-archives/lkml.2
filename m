Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0LMMf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:35:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38715 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0LMMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:35:56 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 2/2] clk: Generic support for fixed-rate clocks
Date: Mon, 13 Dec 2010 20:35:37 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1291774094.269634.503532219345.0.gpush@pororo> <1291774094.270492.31002734529.2.gpush@pororo> <20101213121413.GA29833@pengutronix.de>
In-Reply-To: <20101213121413.GA29833@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012132035.41371.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

> > +extern struct clk_ops clk_fixed_ops;
> > +
> > +#define INIT_CLK_FIXED(name, r) { \
> > +	.clk = INIT_CLK(name.clk, clk_fixed_ops), \
> > +	.rate = (r) \
> > +}
> 
> Is there any other valid usecase for this other than
> 
> struct clk_fixed bla = INIT_CLK_FIXED(bla, rate);
> 
> Otherwise I suggest to convert the macro to:
> 
> #define INIT_CLK_FIXED(name, r) \
> 	struct clk_fixed name = { \
> 		.clk = INIT_CLK(name.clk, clk_fixed_ops), \
> 		.rate = (r) \
> 	}
> 
> This way we do not have to specify the same name twice (and it has
> to be exactly the same name, otherwise it won't compile).

For the system-wide INIT_CLK* macros, I've intentionally made them initalisers 
rather than declarators, so that we can use them in other declarators (ie, the 
usage of INIT_CLK() above). This would be relevant if someone is using 
clk_fixed in their struct - probably not likely, but good to be consistent.

But yes, it would be good to avoid having to specify the name twice - how 
about adding a:

#define DEFINE_CLK_FIXED(name, r) \
	struct clk_fixed name = INIT_CLK_FIXED(name, r)

- just like DEFINE_MUTEX and MUTEX_INITIALIZER.

Cheers,


Jeremy
