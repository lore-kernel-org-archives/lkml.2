Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2GPKUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:20:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2GPKUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:20:40 -0400
Message-ID: <1342434030.4717.2.camel@phoenix>
Subject: Re: [PATCH RFT 1/2] regulator: twl: Fix the formula to calculate
 vsel and voltage for twl6030ldo
From: Axel Lin <axel.lin@gmail.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, loml <linux-omap@vger.kernel.org>
Date: Mon, 16 Jul 2012 18:20:30 +0800
In-Reply-To: <5003DAAA.2070301@ti.com>
References: <1341804151.14367.1.camel@phoenix>
	 <1341831686.4343.7.camel@phoenix> <5003DAAA.2070301@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Monday 09 July 2012 04:31 PM, Axel Lin wrote:
> > 於 一，2012-07-09 於 11:22 +0800，Axel Lin 提到：
> >> In twl6030ldo_set_voltage, current code use below formula to calculate vsel:
> >>          vsel = (min_uV/1000 - 1000)/100 + 1;
> >> This is worng because when min_uV is 1000000 uV, vsel is 1.
> >> It should be 0 in this case.
> 
> Why? Do you know of any documentation which states this?

I double check with the datasheet again now.
You are right in this. So we cannot use linear mapping for
twl6030ldo_ops here.
I'm going to send a patch to fix it, I'd appreciate if someone can
review and test it.


> > I found a problem that before commit 3e3d3be79c, the voltage tables were
> > not linear mapping. So why we can convert these voltage mapping table to
> > Voltage(in mV) = 1000mv + 100mv * (vsel - 1)?
> >
> > Did I miss something?
> 
> All voltage tables before commit '3e3d3be79c' for twl6030 regulators
> were clearly wrong. They assumed similarity with twl4030 regulators
> which was not right.

Good to know that. 
Thanks,
Axel
> 
> regards,
> Rajendra
> 
> >
> > Regards,
> > Axel
> >
> >
> 


