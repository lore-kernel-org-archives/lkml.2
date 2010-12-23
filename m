Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab0LWHAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 02:00:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0LWHAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 02:00:37 -0500
Date: Thu, 23 Dec 2010 08:00:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: provide dummy functions for DMA_ENGINE=n
In-Reply-To: <AANLkTimHHOiRXek9yPwGWvFg5BWU0RF1rptuAE0ijjnW@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1012230759380.29612@axis700.grange>
References: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
 <AANLkTim-1xCmk1S3KhdFazYCizzex0C5c_PtpjQoVkvj@mail.gmail.com>
 <Pine.LNX.4.64.1012230109150.19497@axis700.grange>
 <AANLkTimHHOiRXek9yPwGWvFg5BWU0RF1rptuAE0ijjnW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:4lC0EN/lEA4DpB9PH19BQvUg/6JzmYUwuJwbKahvZpC
 mYxR5Fqm1PSIaM3tXypxmto5/YWqZWXcOhaGAZPzqtrKjLxWXp
 TIjoOgvylyGzDBKGuGuHCuQjZso8Bs0uClVdpHncLzLbfJR58+
 HRwE7A6l/BXTU8K//Bz2qOt8zy3ZbtmpJQ2cpNU2UZ95/x1nnV
 uBQ7An23UcwLYaMnUev/EUpJCATWJ3SW0y2N5+Gt54=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Dan Williams wrote:

> On Wed, Dec 22, 2010 at 4:13 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Wed, 22 Dec 2010, Dan Williams wrote:
> >
> >> On Wed, Dec 22, 2010 at 5:46 AM, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
> >> > unselected.
> >> >
> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> > ---
> >> >  include/linux/dmaengine.h |   13 ++++++++++---
> >> >  1 files changed, 10 insertions(+), 3 deletions(-)
> >>
> >> Is this fixing build errors, or is this just relieving drivers from
> >> needing to surround calls to dma_{request|release}_channel() with
> >> ifdef CONFIG_DMA_ENGINE?  The former makes this more urgent, the
> >> latter can wait for the next merge window.
> >
> > sh_mmcif.c doesn't compile, if configured for DMA, but DMA_ENGINE is
> > unselected. So, yes, this wants to be fixed. But there's more than one way
> > to fix it. I've chosen this one, as it seems more generic to me.
> >
> 
> Yes, it's the right fix.  I was just trying to see if it needs to go
> in now and if there were any implications for -stable.  Unless I am
> missing something drivers/mmc/host/sh_mmcif.c does not even include
> dmaengine.h today so this can wait until the 2.6.38 window.

Right, sorry, DMA support for sh_mmcif.c is only coming in 2.6.38, it's 
currently in next.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
