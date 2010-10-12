Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0JLOKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:10:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44236 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932579Ab0JLOKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:10:21 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 12 Oct 2010 09:10:15 -0500
Subject: RE: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
Thread-Topic: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
Thread-Index: Actp/eb8+w8+xTufTvGJqW9vlhILhgAGONWg
Message-ID: <496565EC904933469F292DDA3F1663E602F47B2FDA@dlee06.ent.ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com>
	<1286226137-1233-2-git-send-email-x0095840@ti.com>
	<1286226137-1233-3-git-send-email-x0095840@ti.com>
	<AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B2BF1@dlee06.ent.ti.com>
 <AANLkTinVzO_B0L09bOG0aWTsQjaXgLeggB+YUgEhL2Sa@mail.gmail.com>
In-Reply-To: <AANLkTinVzO_B0L09bOG0aWTsQjaXgLeggB+YUgEhL2Sa@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Tuesday, October 12, 2010 6:09 AM
> To: Guzman Lugo, Fernando
> Cc: Hiroshi.DOYU@nokia.com; david.cohen@nokia.com; 
> felipe.contreras@nokia.com; ameya.palande@nokia.com; 
> linux-kernel@vger.kernel.org; andy.shevchenko@gmail.com; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv2 2/3] iovmm: add superpages support to 
> fixed da address
> 
> On Mon, Oct 11, 2010 at 6:33 PM, Guzman Lugo, Fernando 
> <fernando.lugo@ti.com> wrote:
> >> > @@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct
> >> sg_table
> >> > *sgt, u32 pa, size_t len)
> >> >        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> >> >                size_t bytes;
> >> >
> >> > -               bytes = iopgsz_max(len);
> >> > +               bytes = max_alignment(da | pa);
> >> > +               bytes = min(bytes, (size_t)iopgsz_max(len));
> >>
> >> Why the size_t casting?
> >
> > To void this warning:
> > arch/arm/plat-omap/iovmm.c:440: warning: comparison of distinct 
> > pointer types lacks a cast
> 
> But how is that possible? iopgsz_max is returning constants, 
> like SZ_1M, so they should not need casts, if anything, the 
> cast should be done in iopgsz_max itself.

The min macro make a "typeof" of the parameter, so the typeof of a 
Constants should be int I think and that's the reason of the warning.

I can use min_t instead to avoid the warning, something like this:

			bytes = min_t(size_t, bytes, iopgsz_max(len));

What do you think?

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 