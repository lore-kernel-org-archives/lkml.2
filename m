Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2K1MKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:10:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58874 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2K1MK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:10:29 -0500
From: "Navada Kanyana, Mukund" <navada@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Topic: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Thread-Index: AQHNzUn3sp+aSR+ZB0iEZwLUiY4GmZf+nu6AgAB/Pg2AAAYlEYAAA0sQ
Date: Wed, 28 Nov 2012 12:10:21 +0000
Message-ID: <6817C817C9581447825BFB369EAC42163E959B84@DBDE01.ent.ti.com>
References: <n> <1354094577-14967-1-git-send-email-navada@ti.com>
 <20121128092924.GJ32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959AED@DBDE01.ent.ti.com>
 <20121128113443.GM32691@opensource.wolfsonmicro.com>
 <6817C817C9581447825BFB369EAC42163E959B6C@DBDE01.ent.ti.com>
 <20121128115638.GO32691@opensource.wolfsonmicro.com>
In-Reply-To: <20121128115638.GO32691@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, November 28, 2012 5:27 PM
> To: Navada Kanyana, Mukund
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered
> pages across regmap range
> 
> On Wed, Nov 28, 2012 at 11:52:22AM +0000, Navada Kanyana, Mukund wrote:
> 
> > static const struct regmap_range_cfg aic325x_ranges[] = {
> >         { .name = "CONF", .range_min = 128,
> >           .range_max = 383,
> >           .selector_reg = 0x0,
> >           .selector_mask = 0xff,
> >           .selector_shift = 0,
> >           .window_start = 0, .window_len =128,
> >         },
> >         { .name = "MINIDSP_A_CM_A", .range_min = AIC325X_ADSP_CM_A_BASE,
> >           .range_max = AIC325X_ADSP_CM_A_BASE + 1152,
> >           .selector_reg = 0x0,
> >           .selector_mask = 0xff,
> >           .selector_shift = 0,
> >           .window_start = 0, .window_len =128,
> >         },
> > };
> 
> You appear to have two different ranges with the same selector and
> window.  I'm really not sure why you expect this to work...  what
> happens when someone reads from the two different ranges simultaneously?
The selector register has to written appropriate page number. Two different ranges cannot be accessed simultaneously without changing the page number in the selector register.
