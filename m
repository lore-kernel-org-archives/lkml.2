Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1ECVlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:41:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41256 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755133Ab1ECVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:41:46 -0400
Date: Tue, 3 May 2011 22:41:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Yong Shen <yong.shen@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC][PATCH] mfd: mc13xxx-core: put mutex lock down to
 mc13xxx_reg_rmw function
Message-ID: <20110503214155.GB7453@opensource.wolfsonmicro.com>
References: <1304440079.16287.7.camel@phoenix>
 <20110503191525.GE11574@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110503191525.GE11574@pengutronix.de>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:15:25PM +0200, Uwe Kleine-König wrote:
> On Wed, May 04, 2011 at 12:27:59AM +0800, Axel Lin wrote:

> > +	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
> > +			mask, value << mc13892_regulators[id].vsel_shift);

> I havn't looked deeply, but I guess this can have unwanted side effects
> here. Before you had:

> 	lock()
> 	do(something)
> 	do(something, else, that, needs, rmw)
> 	unlock()

> and you introduced an unlock()/lock() between these two do()s.

Glancing at the code I wasn't 100% convinced that the original read was
really needed, though I didn't look closely.

> I'm not convinced this change is good, though I agree that

> 	lock()
> 	rmw(...)
> 	unlock()

> looks ugly, but imho this can better be fixed by adding a wrapper for
> that sequence if you really want.

You could also make the rmw store the value somewhere if it's important.
Having to open code the locks everywhere is certainly annoying and error
prone.
