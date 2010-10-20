Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab0JTNDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:03:34 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:44119 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JTNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:03:33 -0400
X-SpamScore: -27
X-BigFish: VS-27(zcb8kz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH] ARM: imx: change mx51.h into mx5x.h
Date: Wed, 20 Oct 2010 06:03:45 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D5B09@az33exm21>
In-Reply-To: <20101020113550.GL2562@matterhorn.lan>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARM: imx: change mx51.h into mx5x.h
Thread-Index: ActwSva74nQVQh/MSwmFZ2gNKlCv/wACs/8w
References: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com> <20101020090122.GH28166@pengutronix.de> <20101020113550.GL2562@matterhorn.lan>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Amit Kucheria <amit.kucheria@canonical.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <daniel@caiaq.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <valentin.longchamp@epfl.ch>
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9KD3ueJ022991

Hello Uwe,

> -----Original Message-----
> From: Amit Kucheria [mailto:amit.kucheria@canonical.com]
> Sent: Wednesday, October 20, 2010 6:36 AM
> To: Uwe Kleine-KÃ¶nig
> Cc: Nguyen Dinh-R00091; linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; s.hauer@pengutronix.de;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> daniel@caiaq.de; Zhang Lily-R58066; valentin.longchamp@epfl.ch
> Subject: Re: [PATCH] ARM: imx: change mx51.h into mx5x.h
> 
> On 10 Oct 20, Uwe Kleine-KÃ¶nig wrote:
> > Hello Dinh,
> >
> > On Tue, Oct 19, 2010 at 04:57:03PM -0500, Dinh.Nguyen@freescale.com
> wrote:
> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > >
> > > In preparation for submitting i.MX53 support, change mx51.h to
> > > mx5x.h so that mx5x.h can contain MX53 information as well.
> > Last time I found time to clean up the imx ports I worked hard that
> e.g.
> > mx27 machines only used MX27_ prefixed symbols, not the MX2x_ ones.  (I
> > don't remember off-hand if I was done, so there might be a few users
> > left.)
> >
> > I'd prefer to just add an mx53.h instead.
> 
> Perhaps this is a good time to ask the question - Why?
> 
> mx53.h will duplicate (almost) everything in mx51.h. And any fixes made
> to
> mx51.h won't make it to mx53.h
> 

MX53 shares about 90% of what is in mx51.h, so I thought it would make more sense for to share a single mx5x.h file. Also, we are planning to add another part, MX50 in the very near future. The way that I am planning for mx5x.h is something like this:

MX5_MMC_ADDR	/*same address shared between both mx51 and mx53*/
MX51_IRAM_ADDR	/*IRAM address for mx51*/
MX53_IRAM_ADDR	/*IRAM address for mx53*/

Per Robert Schwebel's suggestion, I want to do small things at a time.

> Other sub-archs don't do this. e.g. omap uses one common header file and
> then
> a per-SoC file for the differences.
> 
> > > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > >  #ifdef CONFIG_ARCH_MX3
> > > diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-
> mxc/include/mach/mx5x.h
> > > similarity index 100%
> > > rename from arch/arm/plat-mxc/include/mach/mx51.h
> > > rename to arch/arm/plat-mxc/include/mach/mx5x.h
> > > --
> > > 1.6.0.4
> >
> > --
> > Pengutronix e.K.                           | Uwe Kleine-KÃ¶nig
> |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/
> |
> 
> --
> ----------------------------------------------------------------------
> Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
> ----------------------------------------------------------------------

Thanks,
Dinh
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
