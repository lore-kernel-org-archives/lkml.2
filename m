Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2EYICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:02:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:50426 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab2EYICC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:02:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104180085"
Subject: Re: [PATCH] dmaengine: pl330: dont complete descriptor for cyclic
 dma
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, patches@linaro.org,
        Thomas Abraham <thomas.abraham@linaro.org>
In-Reply-To: <CAJe_ZhfV6F-X7+M+NYoH4cG1WWU45MTpHsUiWtK406nhjLPHRg@mail.gmail.com>
References: <1337771851-3431-1-git-send-email-tushar.behera@linaro.org>
	 <4FBDB812.9060407@linaro.org>
	 <CAJe_ZhfV6F-X7+M+NYoH4cG1WWU45MTpHsUiWtK406nhjLPHRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 13:26:07 +0530
Message-ID: <1337932567.1580.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 10:34 +0530, Jassi Brar wrote:
> On 24 May 2012 09:54, Tushar Behera <tushar.behera@linaro.org> wrote:
> > Forgot to add driver author in the original mail, adding now.
> >
> > On 05/23/2012 04:47 PM, Tushar Behera wrote:
> >> Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
> >> cyclic dma") wrongly completes descriptor for cyclic dma, hence following
> >> BUG_ON is still hit with cyclic DMA operations.
> >>
> >> kernel BUG at drivers/dma/dmaengine.h:53!
> >>
> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> >> ---
> >>  drivers/dma/pl330.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> >> index fa3fb21..8c44f17 100644
> >> --- a/drivers/dma/pl330.c
> >> +++ b/drivers/dma/pl330.c
> >> @@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long data)
> >>       /* Pick up ripe tomatoes */
> >>       list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
> >>               if (desc->status == DONE) {
> >> -                     if (pch->cyclic)
> >> +                     if (!pch->cyclic)
> >>                               dma_cookie_complete(&desc->txd);
> >>                       list_move_tail(&desc->node, &list);
> >>               }
> >
> Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
> 
> Obviously a typo, but the commit eab2158 had a tested-by, so I hope
> this doesn't break something else.
Precisely my worry as well. Thomas?

>From the code this looks as the right one.

-- 
~Vinod

