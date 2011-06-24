Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1FXLZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:25:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:6480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab1FXLZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:25:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,419,1304319600"; 
   d="scan'208";a="18017140"
Subject: Re: [Patch] dma: remove DMA_xxBIT_MASK macros
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4DFA69A6.2090507@suse.cz>
References: <20110616090037.GA10326@cr0.redhat.com>
	 <4DFA69A6.2090507@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 16:17:50 +0530
Message-ID: <1308912470.1536.1.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 22:37 +0200, Jiri Slaby wrote:
> On 06/16/2011 11:00 AM, Américo Wang wrote:
> > 
> > git grep shows there are no users in tree, so we can
> > remove them safely.
> > 
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Oh, my __deprecated hack goes away. Nice :).
> 
> Acked-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Vinod Koul <vinod.koul@intel.com>

> 
> > ---
> >  Documentation/feature-removal-schedule.txt |    7 -------
> >  include/linux/dma-mapping.h                |   21 ---------------------
> >  2 files changed, 0 insertions(+), 28 deletions(-)
> > 
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index 72e2384..8e2d816 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -474,13 +474,6 @@ Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >  
> >  ----------------------------
> >  
> > -What: 	DMA_xxBIT_MASK macros
> > -When:	Jun 2011
> > -Why:	DMA_xxBIT_MASK macros were replaced with DMA_BIT_MASK() macros.
> > -Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > -
> > -----------------------------
> > -
> >  What:	iwlwifi disable_hw_scan module parameters
> >  When:	2.6.40
> >  Why:	Hareware scan is the prefer method for iwlwifi devices for
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index ba8319a..dc77808 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -54,27 +54,6 @@ struct dma_map_ops {
> >  
> >  #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
> >  
> > -typedef u64 DMA_nnBIT_MASK __deprecated;
> > -
> > -/*
> > - * NOTE: do not use the below macros in new code and do not add new definitions
> > - * here.
> > - *
> > - * Instead, just open-code DMA_BIT_MASK(n) within your driver
> > - */
> > -#define DMA_64BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(64)
> > -#define DMA_48BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(48)
> > -#define DMA_47BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(47)
> > -#define DMA_40BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(40)
> > -#define DMA_39BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(39)
> > -#define DMA_35BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(35)
> > -#define DMA_32BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(32)
> > -#define DMA_31BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(31)
> > -#define DMA_30BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(30)
> > -#define DMA_29BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(29)
> > -#define DMA_28BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(28)
> > -#define DMA_24BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(24)
> > -
> >  #define DMA_MASK_NONE	0x0ULL
> >  
> >  static inline int valid_dma_direction(int dma_direction)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 


-- 
~Vinod

