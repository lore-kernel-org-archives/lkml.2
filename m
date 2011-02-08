Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1BHBkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:40:46 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58797 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1BHBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:40:43 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Colin Cross <ccross@google.com>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Tue, 8 Feb 2011 09:40:32 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com> <1297058877.800158.458894385837.1.gpush@pororo> <AANLkTi=5FNvWKQf6cRt4wNejC7u4XKsqLp9Pwc2Z45_3@mail.gmail.com>
In-Reply-To: <AANLkTi=5FNvWKQf6cRt4wNejC7u4XKsqLp9Pwc2Z45_3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102080940.33251.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> > +int clk_enable(struct clk *clk)
> > +{
> > +       int ret = 0;
> > +
> > +       if (!clk->ops->enable)
> > +               return 0;
> > +
> > +       spin_lock(&clk->enable_lock);
> 
> spin_lock_irqsave/spin_unlock_irqrestore.  This could get called with
> irqs on or off.

Ah, I had planned to change this but (obviously) didn't get to it. Thanks for 
the reminder, I'll include this in the next revision.

Cheers,


Jeremy
