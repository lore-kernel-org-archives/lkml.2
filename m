Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2FRLsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:48:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34398 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab2FRLsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:48:41 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>, Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5b39csQgAf6AbA=
Date: Mon, 18 Jun 2012 11:48:34 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix> 
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


Hi Axel,

Thanks for the patch,

On Wed, Jun 13, 2012 at 14:39:27, AnilKumar, Chimata wrote:
> Hi Axel,
> 
> On Wed, Jun 13, 2012 at 08:57:11, Axel Lin wrote:
> > This patch converts .is_enabled and .get_voltage_sel to
> > regulator_is_enabled_regmap and regulator_get_voltage_sel_regmap.
> > 
> > For .enable, .disable, and .set_voltage_sel, the write protect level is either
> > 1 or 2. So we cannot use regulator_[enable|disable|set_voltage_sel]_regmap.
> > 
> > Now we store the enable reg/mask and vsel reg/mask in regulator_desc,
> > so we can remove enable_mask, set_vout_reg, and set_vout_mask from
> > struct tps_info.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> > Hi AnilKumar,
> > Any chance to test this patch on your hardware?
> 
> I will give the status in a day or two.

Your patch seems to be working but we have to fix the below issue which is missed in
earlier patch "regulator: core: Use a struct to pass in regulator runtime configuration"
from Mark.

Basically regmap pointer is missed out in runtime configutaion data. Without this we
can see NULL pointer exception because config.regmap is NULL.

+	config.regmap = tps->regmap;

If this is required then same applicable to all the regulators which is modified for
"runtime config".

If not, I missed out some basic stuff here could you please tell me how regmap pointer
is used across the regulator in the current tree?

Regards
AnilKumar