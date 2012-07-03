Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2GCHKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:10:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33589 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2GCHKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:10:03 -0400
Message-ID: <1341299385.4669.2.camel@phoenix>
Subject: RE: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 03 Jul 2012 15:09:45 +0800
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9E8DAD@DBDE01.ent.ti.com>
References: <1341284473.18757.2.camel@phoenix>
	 <1341284755.18757.5.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
	 <1341293168.3241.7.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8DAD@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In side tps65217_pmic_map_voltage() we have
> 
> tps->info[rid]->uv_to_vsel(850000, &sel) nothing but
> tps65217_uv_to_vsel1(850000, &sel);
> 
> sel = (((850000 - 900000) + (25000) - 1) / (25000));
> sel = ((-25001)/(25000));
> sel = -1; /* Which is not expected */
> 
> Ideally this would be the change
> 
> 	if (min_uV < tps->info[rid]->min_uV)
> 		min_uV = tps->info[rid]->min_uV;
> 
ok. I got your point now.

So if min_uV < tps->info[rid]->min_uV, we need to set
min_uV = tps->info[rid]->min_uV.
This is because the equation we used in uv_to_vsel() does not allow
min_uV < tps->info[rid]->min_uV, otherwise it returns negative selector.


> 	if (max_uV > tps->info[rid]->max_uV)
> 		max_uV = tps->info[rid]->max_uV;

This looks not necessary. the equation in uv_to_vsel() does not use
max_uV.

> 
> 	if (max_uV < tps->info[rid]->min_uV ||
> 			min_uV > tps->info[rid]->max_uV)
> 		return -EINVAL;
> 
> If this is not the case then I am completely in a wrong direction.
You are right in this case. I'll send a v2 for review.

Thanks for the review,
Axel


