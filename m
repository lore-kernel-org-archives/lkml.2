Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab2GCF0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:26:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46788 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2GCF0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:26:15 -0400
Message-ID: <1341293168.3241.7.camel@phoenix>
Subject: RE: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 03 Jul 2012 13:26:08 +0800
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
References: <1341284473.18757.2.camel@phoenix>
	 <1341284755.18757.5.camel@phoenix>
	 <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Case 1:-
> ------
> 
> tps->info[rid]->min_uV = 600000;
> tps->info[rid]->max_uV = 1100000;
> 
> If we do regulator_set_voltage(reg, 550000, 1100000);
> 
> This results into error condition and how can we handle with this?

In original code, it returns error. ( I think which is wrong.)

What we want is to set the smallest voltage within the specified voltage
range.
With this patch, calling regulator_set_voltage(reg, 550000, 1100000);
is the same as calling regulator_set_voltage(reg, 600000, 1100000);
It will set the voltage to 600000 uV.

> 
> Case 2:-
> ------
> 
> I think the current code handles this case as well.
> 
> There might be a case where board/DT data is false like
> 
> tps->info[rid]->min_uV = 1100000;
> tps->info[rid]->max_uV = 600000;
> 
I don't get it.
You mean the case min_uV is greater than max_uV?

My understanding of current implementation is that the
tps->info[rid]->min_uV and tps->info[rid]->max_uV are not controlled by
board/DT data. They are defined in tps65217_pmic_regs[].

> regulator_set_voltage(reg, 650000, 1100000);
> 
> Regards
> AnilKumar


