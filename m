Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab2GCHQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:16:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34462 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCHQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:16:43 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Topic: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Index: AQHNWOrTmY5gFg9gAUCbVVRddR0fhJcXJUuA
Date: Tue, 3 Jul 2012 07:16:03 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9E8E0E@DBDE01.ent.ti.com>
References: <1341284473.18757.2.camel@phoenix>
	 <1341284755.18757.5.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
	 <1341293168.3241.7.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8DAD@DBDE01.ent.ti.com>
 <1341299385.4669.2.camel@phoenix>
In-Reply-To: <1341299385.4669.2.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 12:39:45, Axel Lin wrote:
> 
> > In side tps65217_pmic_map_voltage() we have
> > 
> > tps->info[rid]->uv_to_vsel(850000, &sel) nothing but
> > tps65217_uv_to_vsel1(850000, &sel);
> > 
> > sel = (((850000 - 900000) + (25000) - 1) / (25000));
> > sel = ((-25001)/(25000));
> > sel = -1; /* Which is not expected */
> > 
> > Ideally this would be the change
> > 
> > 	if (min_uV < tps->info[rid]->min_uV)
> > 		min_uV = tps->info[rid]->min_uV;
> > 
> ok. I got your point now.
> 
> So if min_uV < tps->info[rid]->min_uV, we need to set
> min_uV = tps->info[rid]->min_uV.
> This is because the equation we used in uv_to_vsel() does not allow
> min_uV < tps->info[rid]->min_uV, otherwise it returns negative selector.
> 
> 
> > 	if (max_uV > tps->info[rid]->max_uV)
> > 		max_uV = tps->info[rid]->max_uV;
> 
> This looks not necessary. the equation in uv_to_vsel() does not use
> max_uV.
> 

Yes, I agree.

Regards
AnilKumar