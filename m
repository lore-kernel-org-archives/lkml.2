Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2GRJ4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:56:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49934 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab2GRJ4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:56:09 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] regulator: tps65217: fix build error if REGULATOR is
 not enabled
Thread-Topic: [PATCH] regulator: tps65217: fix build error if REGULATOR is
 not enabled
Thread-Index: AQHNZLBltySQ8gWfykuGTjdobYDAi5cubl2AgABcyGA=
Date: Wed, 18 Jul 2012 09:55:57 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9F8BD7@DBDE01.ent.ti.com>
References: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
 <20120718094449.GA22739@opensource.wolfsonmicro.com>
In-Reply-To: <20120718094449.GA22739@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Wed, Jul 18, 2012 at 15:14:49, Mark Brown wrote:
> On Wed, Jul 18, 2012 at 12:11:03PM +0530, AnilKumar Ch wrote:
> > Fixes below build error if CONFIG_REGULATOR is not enabled.
> > 
> > drivers/built-in.o: In function `tps65217_probe':
> > tps65217.c:(.devinit.text+0x13e37): undefined reference to `of_regulator_match'
> 
> This isn't a patch to the regulator driver, this is a patch to the MFD.
> Normally this would be fixed by making the MFD driver not depend on the
> regulator API - why is the MFD driver using the regulator API?
> 

Regulators platform data is added to platform device in MFD driver, which we
need for regulator driver, of_regulator_match() is used to check the regulator
consumers if we pass DT data. If we do not enable CONFIG_REGULATOR then
of_regulator_match() is not exported, so we see this error.

Regards
AnilKumar

