Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab1BGIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:23:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44021 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1BGIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:23:14 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Dima Zavin <dima@android.com>
Subject: Re: [RFC,PATCH 1/3] Add a common struct clk
Date: Mon, 7 Feb 2011 16:22:55 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; x86_64; ; )
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "Uwe =?iso-8859-15?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201102011711.31258.jeremy.kerr@canonical.com> <1297058877.800158.458894385837.1.gpush@pororo> <AANLkTim1S9zpebn3yj1fBZTtOkqj2FLwhYWBZ2HXJajR@mail.gmail.com>
In-Reply-To: <AANLkTim1S9zpebn3yj1fBZTtOkqj2FLwhYWBZ2HXJajR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071622.56163.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dima,

> > +int clk_prepare(struct clk *clk)
> > +{
> > +       int ret = 0;
> > +
> > +       if (!clk->ops->prepare)
> > +               return 0;
> > +
> > +       mutex_lock(&clk->prepare_lock);
> > +       if (clk->prepare_count == 0)
> > +               ret = clk->ops->prepare(clk);
> > +
> > +       if (!ret)
> > +               clk->prepare_count++;
> > +       mutex_unlock(&clk->prepare_lock);
> > +
> > +       return 0;
> 
> return ret;

Good catch, thanks.


Jeremy
