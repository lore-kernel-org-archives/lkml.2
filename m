Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0KDJbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:31:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32997 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab0KDJbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:31:09 -0400
From: "Lesly Arackal Manuel" <leslyam@ti.com>
To: "'Nayak, Rajendra'" <rnayak@ti.com>,
        "'Liam Girdwood'" <lrg@slimlogic.co.uk>
Cc: "'Axel Lin'" <axel.lin@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Juha Keski-Saari'" <ext-juha.1.keski-saari@nokia.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1287736702.2996.4.camel@mola> <20101022153006.GB16521@opensource.wolfsonmicro.com> <1287841635.7486.3.camel@odin> <0680EC522D0CC943BC586913CF3768C003FF2DAF9D@dbde02.ent.ti.com>
Subject: RE: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
Date: Thu, 4 Nov 2010 15:00:55 +0530
Message-ID: <4892AA4CA40C485CBF3C8BD5F3B35016@india.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003FF2DAF9D@dbde02.ent.ti.com>
Thread-Index: ActyuNFPXxwj6HhHRf2hO4plS+6DBQCPQjSAAcNCJyA=
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have tested it with MMC card inserted on OMAP3630SDP board (using OMAP3
integration tree).

The changes seem to be valid.

The i2c_transfer() returns '1' on success and the twl_i2c_write() which
calls i2c_transfer returns '0' if success and err value if it fails.

After writing the MSB if it returns with check:
if (status >= 0)
	return status;
It is not writing the LSB.

So it should be:
if (status < 0)
	return status;

Regards,
Lesly AM

> -----Original Message-----
> From: Nayak, Rajendra [mailto:rnayak@ti.com]
> Sent: Tuesday, October 26, 2010 3:40 PM
> To: Liam Girdwood
> Cc: Axel Lin; linux-kernel; Juha Keski-Saari; Mark Brown; Manuel, Lesly
> Arackal
> Subject: RE: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
> 
> 
> 
> > -----Original Message-----
> > From: Liam Girdwood [mailto:lrg@slimlogic.co.uk]
> > Sent: Saturday, October 23, 2010 7:17 PM
> > To: Nayak, Rajendra
> > Cc: Axel Lin; linux-kernel; Juha Keski-Saari; Mark Brown
> > Subject: Re: [PATCH] regulator: twl-regulator - fix twlreg_set_mode
> >
> > On Fri, 2010-10-22 at 08:30 -0700, Mark Brown wrote:
> > > On Fri, Oct 22, 2010 at 04:38:22PM +0800, Axel Lin wrote:
> > > > The Singular Message is 16 bits:
> > > >         DEV_GRP[15:13] MT[12]  RES_ID[11:4]  RES_STATE[3:0]
> > > >
> > > > Current implementation return immedially after sucessfuly write MSB
> part.
> > > > To properly set mode, we need to write the complete message ( MSB
> and LSB ).
> > > >
> > > > In twl.h, now we have defines for PM Master module register offsets,
> > > > use it instead of hard coded 0x15/0x16.
> > > >
> > > > Use "message & 0xff" to ensure we send correct value for LSB.
> > > >
> > > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > >
> > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > >
> > > > I don't have this hardware handy, I appreciate if someone who has
> the
> > > > hardware can test this patch.
> > >
> > > I beleive Liam has appropriate hardware.
> >
> > Rejendra, care to test this ?
> 
> Sure, either me or Lesly will test this on one of the twl4030 based
> platforms
> and update.
> 
> >
> > Thanks
> >
> > Liam
> > --
> > Freelance Developer, SlimLogic Ltd
> > ASoC and Voltage Regulator Maintainer.
> > http://www.slimlogic.co.uk


