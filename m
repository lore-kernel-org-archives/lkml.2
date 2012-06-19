Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2FSGm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:42:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59256 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2FSGmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:42:25 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Topic: [PATCH v2] regulator: add new regulator driver for lp872x
Thread-Index: Ac1K013lgBKp+AGARUeXJs2xlf9z8P//330A//m62lA=
Date: Tue, 19 Jun 2012 06:42:19 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FB880@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
 <CAF+7xWnM9Z2eBAiuSidW9AUfo+M4-JHHzN3jgn+1bwH3he3rAQ@mail.gmail.com>
In-Reply-To: <CAF+7xWnM9Z2eBAiuSidW9AUfo+M4-JHHzN3jgn+1bwH3he3rAQ@mail.gmail.com>
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

> LP872X_MAX_REGULATORS is 9.
> But for LP8720, the LP8720_NUM_REGULATORS is 6.
> So this should be:
>         for (i = 0 ; i < lp->num_regulators  ; i++)

Thanks for your opinion.
In the patch v3, max loop count will be variable in case of PMU.

static struct regulator_init_data
*lp872x_find_regulator_init_data(int idx, struct lp872x *lp)
{
	int max_regulators;

	switch (lp->chipid) {
	case LP8720:
		max_regulators = LP8720_NUM_REGULATORS;
		break;
	case LP8725:
		max_regulators = LP8725_NUM_REGULATORS;
		break;
	default:
		return NULL;
	}

	for (i = 0 ; i < max_regulators ; i++)

...

Thanks & BR
Milo -
