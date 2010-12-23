Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0LWAOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:14:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0LWAOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:14:03 -0500
Date: Thu, 23 Dec 2010 01:13:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: provide dummy functions for DMA_ENGINE=n
In-Reply-To: <AANLkTim-1xCmk1S3KhdFazYCizzex0C5c_PtpjQoVkvj@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1012230109150.19497@axis700.grange>
References: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
 <AANLkTim-1xCmk1S3KhdFazYCizzex0C5c_PtpjQoVkvj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:poSqZAW7dG19KPbjns8Aqzsr8cQzr21GEBscPGNhnnL
 OJYnMkM6Qmo/DZDfRIkffFYaNyCD2eKhlsxvIBCXscMv9uUQIl
 b/v23RnAC76DqDyJChl7tQdRsdVEGkyJlNNYnPXoiUwaCSzQa+
 Z7sf4CD+WYdfae9/GLRpXygm3sareIkp9H2rvKN69cVxYNyXuJ
 2urBuCvOU6Y8CGvrfrnuDz6neZoVPLnNsSTKjKsMBY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Dan Williams wrote:

> On Wed, Dec 22, 2010 at 5:46 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
> > unselected.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  include/linux/dmaengine.h |   13 ++++++++++---
> >  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> Is this fixing build errors, or is this just relieving drivers from
> needing to surround calls to dma_{request|release}_channel() with
> ifdef CONFIG_DMA_ENGINE?  The former makes this more urgent, the
> latter can wait for the next merge window.

sh_mmcif.c doesn't compile, if configured for DMA, but DMA_ENGINE is 
unselected. So, yes, this wants to be fixed. But there's more than one way 
to fix it. I've chosen this one, as it seems more generic to me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
