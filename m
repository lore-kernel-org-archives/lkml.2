Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab1DNMt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:49:28 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:42740 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257Ab1DNMt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:49:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19R1is9MOFlOMqfkCBqBntn
Date: Thu, 14 Apr 2011 15:49:16 +0300
From: Tony Lindgren <tony@atomide.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110414124916.GB3336@atomide.com>
References: <1299134429.100626.661279191478.0.gpush@pororo>
 <1299134429.101167.227629761799.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299134429.101167.227629761799.1.gpush@pororo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Kerr <jeremy.kerr@canonical.com> [110303 08:39]:
> 
> Platforms can enable the generic struct clock through
> CONFIG_USE_COMMON_STRUCT_CLK. In this case, the clock infrastructure
> consists of a common struct clk:
> 
> struct clk {
> 	const struct clk_ops	*ops;
> 	unsigned int		enable_count;
> 	unsigned int		prepare_count;
> 	spinlock_t		enable_lock;
> 	struct mutex		prepare_lock;
> };
> 
> And a set of clock operations (defined per type of clock):
> 
> struct clk_ops {
> 	int             (*enable)(struct clk *);
> 	void            (*disable)(struct clk *);
> 	unsigned long   (*get_rate)(struct clk *);
> 	[...]
> };
> 
> To define a hardware-specific clock, machine code can "subclass" the
> struct clock into a new struct (adding any device-specific data), and
> provide a set of operations:
> 
> struct clk_foo {
> 	struct clk	clk;
> 	void __iomem	*some_register;
> };
> 
> struct clk_ops clk_foo_ops = {
> 	.get_rate = clk_foo_get_rate,
> };

Anybody looked into passing the clock register and type
from device tree?

To me it looks like the above would allow doing that
pretty easily while avoiding duplicating all the
data from devicetree into struct clk_foo.

Tony
