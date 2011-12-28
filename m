Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1L1LgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 06:36:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45754 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab1L1LgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 06:36:06 -0500
Date: Wed, 28 Dec 2011 11:36:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] TPS65217: Add tps65217 regulator driver
Message-ID: <20111228113602.GC24405@opensource.wolfsonmicro.com>
References: <1324617696-14350-1-git-send-email-anilkumar@ti.com>
 <20111223111538.GE2834@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC103ECAB@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC103ECAB@DBDE01.ent.ti.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 09:14:31AM +0000, AnilKumar, Chimata wrote:
> On Fri, Dec 23, 2011 at 16:45:39, Mark Brown wrote:
> > On Fri, Dec 23, 2011 at 10:51:36AM +0530, AnilKumar Ch wrote:

> > > +/* Supported voltage values for regulators (in milliVolts) */
> > > +static const u16 VDCDC1_VSEL_table[] = {
> > > +	900, 925, 950, 975,
> > > +	1000, 1025, 1050, 1075,
> > > +	1100, 1125, 1150, 1175,
> > > +	1200, 1225, 1250, 1275,
> > > +	1300, 1325, 1350, 1375,
> > > +	1400, 1425, 1450, 1475,
> > > +	1500, 1550, 1600, 1650,
> > > +	1700, 1750, 1800,
> > > +};

> > You should replace all these vsel tables with calculations in the code,
> > they're all regular steps and some of the tables are getting a bit
> > large.

> TPS65217 don't have any formula for computing the next voltage value. In
> entire voltage scale range there is an inconsistency in the step size.

if (voltage < 1500)
	...
else
	...

> > > +	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
> > > +		int mV = tps->info[dcdc]->table[vsel];
> > > +		int uV = mV * 1000;
> > > +
> > > +		/* Break at the first in-range value */
> > > +		if (min_uV <= uV && uV <= max_uV)
> > > +			break;
> > > +	}

> > If you are going to use a table you should implement set_voltage_sel()
> > which will do the table walk for you, but like I say you should just be
> > using a calculation.

> As per my understanding set_voltage_sel() is used to set a voltage if we
> know the selector. But here it's different case, based on the min and
> max voltages we have to identify the selector. For identifying the selector
> we have to walk through the table. I did not find any helper functions
> for walking through the table.

No, that would be totally unusable by anything.  If you implement _sel
the core will do the mapping into a selector for you; if you take the
time to look at the code you'll see that it's implementing exactly the
above loop.
