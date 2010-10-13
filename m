Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0JMQoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:44:03 -0400
Received: from smtp.nokia.com ([192.100.122.233]:31501 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0JMQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:44:01 -0400
From: Felipe Contreras <felipe.contreras@nokia.com>
Subject: RE: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
To: fernando.lugo@ti.com, felipe.contreras@gmail.com
Cc: hiroshi.doyu@nokia.com, david.cohen@nokia.com, ameya.palande@nokia.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org
In-Reply-To: <496565EC904933469F292DDA3F1663E602F47B2FDA@dlee06.ent.ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com> <1286226137-1233-2-git-send-email-x0095840@ti.com> <1286226137-1233-3-git-send-email-x0095840@ti.com> <AANLkTimF5HqA0pbp7NXOXxOcuMMJWp9yuJPsw8-iPKjh@mail.gmail.com> <496565EC904933469F292DDA3F1663E602F47B2BF1@dlee06.ent.ti.com> <AANLkTinVzO_B0L09bOG0aWTsQjaXgLeggB+YUgEhL2Sa@mail.gmail.com> <496565EC904933469F292DDA3F1663E602F47B2FDA@dlee06.ent.ti.com>
User-Agent: notmuch 0.3.1-85-ge35d5aa
Message-ID: <1286988203-notmuch-felipe.contreras@nokia.com>
Date: Wed, 13 Oct 2010 19:43:50 +0300
X-OriginalArrivalTime: 13 Oct 2010 16:43:56.0159 (UTC) FILETIME=[D3B530F0:01CB6AF5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fernando.lugo@ti.com wrote:
> > On Mon, Oct 11, 2010 at 6:33 PM, Guzman Lugo, Fernando 
> > <fernando.lugo@ti.com> wrote:
> > >> > @@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct
> > >> sg_table
> > >> > *sgt, u32 pa, size_t len)
> > >> >        for_each_sg(sgt->sgl, sg, sgt->nents, i) {
> > >> >                size_t bytes;
> > >> >
> > >> > -               bytes = iopgsz_max(len);
> > >> > +               bytes = max_alignment(da | pa);
> > >> > +               bytes = min(bytes, (size_t)iopgsz_max(len));
> > >>
> > >> Why the size_t casting?
> > >
> > > To void this warning:
> > > arch/arm/plat-omap/iovmm.c:440: warning: comparison of distinct 
> > > pointer types lacks a cast
> > 
> > But how is that possible? iopgsz_max is returning constants, 
> > like SZ_1M, so they should not need casts, if anything, the 
> > cast should be done in iopgsz_max itself.
> 
> The min macro make a "typeof" of the parameter, so the typeof of a 
> Constants should be int I think and that's the reason of the warning.
> 
> I can use min_t instead to avoid the warning, something like this:
> 
> 			bytes = min_t(size_t, bytes, iopgsz_max(len));
> 
> What do you think?

Right, I forgot about that one... much better.

-- 
Felipe Contreras
