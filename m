Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2FSHBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:01:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2FSHBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:01:38 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Topic: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Index: Ac1K013lgBKp+AGARUeXJs2xlf9z8P//xrWA//mbS6A=
Date: Tue, 19 Jun 2012 07:01:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FB8A7@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
 <20120615132130.GH4482@opensource.wolfsonmicro.com>
In-Reply-To: <20120615132130.GH4482@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > +	if (chip == LP8720) {
> > +		mask = LP8720_TIMESTEP_M;
> > +		shift = LP8720_TIMESTEP_S;
> > +		time_usec = &lp8720_time_usec[0];
> > +		size = ARRAY_SIZE(lp8720_time_usec);
> > +	} else if (chip == LP8725) {
> > +		mask = LP8725_TIMESTEP_M;
> > +		shift = LP8725_TIMESTEP_S;
> > +		time_usec = &lp8725_time_usec[0];
> > +		size = ARRAY_SIZE(lp8725_time_usec);
> > +	} else {
> > +		return -EINVAL;
> > +	}
> 
> This should be a switch statement.
> 
> > +static int lp8725_buck_set_current_limit(struct regulator_dev *rdev,
> > +					int min_uA, int max_uA)
> > +{
> > +	struct lp872x *lp = rdev_get_drvdata(rdev);
> > +	enum lp872x_regulator_id buck = rdev_get_id(rdev);
> > +	int i, max = ARRAY_SIZE(lp8725_buck_uA);
> > +	u8 addr, val;
> > +
> > +	if (buck == LP8725_ID_BUCK1)
> > +		addr = LP8725_BUCK1_VOUT2;
> > +	else if (buck == LP8725_ID_BUCK2)
> > +		addr = LP8725_BUCK2_VOUT2;
> > +	else
> > +		return -EINVAL;
> 
> Again, switch statement.
> 

In patch v3, some if-statements will be replaced with switch-statements.
Thank you.

Best Regards,
Milo
