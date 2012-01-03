Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab2ACGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 01:16:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42779 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2ACGQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 01:16:25 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH V2 2/2] TPS65217: Add tps65217 regulator driver
Thread-Topic: [PATCH V2 2/2] TPS65217: Add tps65217 regulator driver
Thread-Index: AQHMyUzdKQ0OxcMghE6NObDPLpCPMZX4ssMAgAByqDA=
Date: Tue, 3 Jan 2012 06:16:18 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC104023C@DBDE01.ent.ti.com>
References: <1325508522-23217-1-git-send-email-anilkumar@ti.com>
 <20120102131648.GJ4300@opensource.wolfsonmicro.com>
In-Reply-To: <20120102131648.GJ4300@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 02, 2012 at 18:46:48, Mark Brown wrote:
> On Mon, Jan 02, 2012 at 06:18:42PM +0530, AnilKumar Ch wrote:
> > This patch adds tps65217 PMIC as a regulator
> 
> Use subject lines appropriate for the subsystem you're submitting
> against.
> 
> > +config REGULATOR_TPS65217
> > +	tristate "TI TPS65217 Power regulators"
> > +	depends on (I2C && MFD_TPS65217)
> 
> Should only depend on the MFD, there's no direct I2C usage.

Agree, removed I2C

> 
> > +static unsigned int tps65217_vsel_to_uv_range0(unsigned int vsel)
> > +{
> > +	unsigned int uV = 0;
> > +
> > +	if (vsel <= 24)
> > +		uV = ((vsel * 25000) + 900000);
> > +	else if (vsel > 24 && vsel <= 52)
> > +		uV = (((vsel - 24) * 50000) + 1500000);
> > +	else if (vsel > 52 && vsel <= 56)
> > +		uV = (((vsel - 52) * 100000) + 2900000);
> 
> No need for the > checks as this is already taken care of by being in
> the else clause.

Changed

> 
> > +static unsigned int tps65217_vsel_to_uv_range2(unsigned int vsel)
> > +{
> > +	unsigned int uV = 0;
> > +
> > +	if (vsel <= 8)
> > +		uV = ((vsel * 50000) + 1500000);
> > +	else if (vsel > 9 && vsel <= 13)
> > +		uV = (((vsel - 8) * 100000) + 1900000);
> > +	else if (vsel > 13)
> > +		uV = (((vsel - 13) * 50000) + 2400000);
> > +
> > +	return uV;
> 
> In all of these functions there ought to be a check to make sure vsel
> isn't out of range and return an error if it is.

Added error checks as well.

> 
> > +static int tps65217_pmic_set_bits(struct tps65217 *tps, unsigned int reg,
> > +		unsigned int mask, unsigned int val, unsigned int level)
> > +{
> 
> To repeat what I said when reviewing the previous version of the patch
> things like this shouldn't be open coded in individual function drivers,
> they should be in the MFD driver.  There is *nothing* PMIC specific
> about register access.
> 
> I've stopped reading at this point.
> 

Mark sorry about this, password protected writes/update bits are required
only for regulator so I put it in regulator driver. I got your point, will
be moved to MFD driver.

Thanks for your patience here.

Regards,
AnilKumar
