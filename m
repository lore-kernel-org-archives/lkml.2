Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1GEIcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:32:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37739 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1GEIcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:32:14 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Chemparathy, Cyril" <cyril@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 5 Jul 2011 14:02:00 +0530
Subject: RE: [RFC/RFT 1/2] gpio/basic_mmio: add support for enable register
Thread-Topic: [RFC/RFT 1/2] gpio/basic_mmio: add support for enable register
Thread-Index: Acw62v/W1sm042e7RiGgnacPW4rksQAD2aSg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024D91A45E@dbde02.ent.ti.com>
References: <cover.1309840042.git.nsekhar@ti.com>
 <83915224c24e43224272b1bf570cddb9545279a6.1309840042.git.nsekhar@ti.com>
 <4E12AC10.9020206@gmail.com>
In-Reply-To: <4E12AC10.9020206@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Tue, Jul 05, 2011 at 11:45:44, Ryan Mallon wrote:
> On 05/07/11 15:10, Sekhar Nori wrote:
> > Some GPIO controllers have an enable register
> > which needs to be written to before a GPIO
> > can be used.
> >
> > Add support for enabling the GPIO. At this
> > time inverted logic for enabling the GPIO
> > is not supported. This can be done by adding
> > a disable register as and when a controller
> > with this comes along.
> >
> > Signed-off-by: Sekhar Nori<nsekhar@ti.com>
> > ---
> >
> <snip>
> 
> > static int bgpio_setup_io(struct bgpio_chip *bgc,
> >   			  void __iomem *dat,
> > @@ -369,6 +401,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
> >   			 void __iomem *clr,
> >   			 void __iomem *dirout,
> >   			 void __iomem *dirin,
> > +			 void __iomem *en,
> >   			 bool big_endian)
> 
> The arguments to this function are getting a bit unwieldy :-). Maybe we 
> need to introduce something like:
> 
> struct bgpio_chip_info {
>      struct device *dev;
>      unsigned long sz;
>      void __iomem *dat;
>      void __iomem *set;
>      void __iomem *clr;
>      void __iomem *dirout;
>      void __iomem *dirin;
>      void __iomem *en;
>      bool big_endian;
> };
> 
> and pass that to bgpio_init instead. It would have the added benefits of 
> making the drivers more readable and that bgpio_chip_info structs in the 
> drivers can probably be marked __initdata also.
> 
> Since you are already having to touch all of the call sites for 
> bgpio_init this could be done as a separate patch along with this series.

Agreed. I can do this if Grant too thinks this is a
pre-requisite to adding new functionality.

Thanks,
Sekhar

