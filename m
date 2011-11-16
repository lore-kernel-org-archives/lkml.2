Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1KPNnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:43:33 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53611 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab1KPNnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:43:31 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: RE: [PATCH 1/1] gpio: introduce gpio_export_array to ease export
 for gpio arrays
Thread-Topic: [PATCH 1/1] gpio: introduce gpio_export_array to ease export
 for gpio arrays
Thread-Index: AQHMo3ri2rhZMbr1OUmiHWFlIIORIpWuqLuAgADUhuA=
Date: Wed, 16 Nov 2011 13:43:27 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7722D5CE0@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321350841-8549-1-git-send-email-dong.aisheng@linaro.org>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805DEC@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805DEC@HQMAIL01.nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Stephen Warren
> Sent: Wednesday, November 16, 2011 2:37 AM
> To: Dong Aisheng; linux-kernel@vger.kernel.org
> Cc: grant.likely@secretlab.ca; arnd@arndb.de
> Subject: RE: [PATCH 1/1] gpio: introduce gpio_export_array to ease export
> for gpio arrays
> 
> Dong Aisheng wrote at Tuesday, November 15, 2011 2:54 AM:
> > Introduce gpio_export_array function to ease the export operation for
> > gpio arrays.
> > This can cooperate with the exist gpio_request_array function.
> ...
> > +/**
> > + * gpio_export_array - export multiple GPIOs in a single call
> > + * @array:	array of the 'struct gpio'
> > + * @num:	how many GPIOs in the array
> > + */
> > +int gpio_export_array(const struct gpio *array, size_t num,
> > +			bool direction_may_change)
> 
> Should direction_may_change be added to "struct gpio" so it can vary per
> pin?
> 
I just thougt that after adding this member(or flag) into struct gpio,
we may not need gpio_export_array function. It can be done in gpio_request_one
by checking the flag just like wolfram's patch does (I just found his patch).
It seems his patch is more light to implement this function.

> I might this new function to create its own parameter type instead of re-
> using struct gpio, but I guess the main value here is re-using the data
> passed to both request_array and export_array.
> 
Agree. :-)

Regards
Dong Aisheng

