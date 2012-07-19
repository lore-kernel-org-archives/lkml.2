Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2GSJGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:06:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39680 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2GSJGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:06:20 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: RE: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Topic: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Index: Ac1k8i6xsVnWXGXAR2GxE5eW2yYAsf//fuIA//5JPxA=
Date: Thu, 19 Jul 2012 09:05:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD9B7@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FD79B@DQHE02.ent.ti.com>
 <20120718145032.GB4495@opensource.wolfsonmicro.com>
In-Reply-To: <20120718145032.GB4495@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +struct lp8788_irq_data {
> > +	struct lp8788 *lp;
> > +	struct irq_domain *irqdm;
> > +	struct mutex irq_lock;
> > +	struct delayed_work work;
> > +	struct workqueue_struct *thread;
> > +	int enabled[LP8788_INT_MAX];
> > +	int irq;
> > +	int irq_base;
> > +};
> 
> Can you use regmap-irq?  If not can we fix things so that's possible?

Mark,

Currently, there is some limitation on regmap-irq with LP8788.
In LP8788, interrupt is enabled when the IRQ bit is set to 1.
This concept is opposite to interrupt-mask register.
So experimental patch has been sent.
Could you please review it ?

Patch title: [PATCH 2/2] regmap-irq: support different type of irq register

Thank you.

Best Regards,
Milo



