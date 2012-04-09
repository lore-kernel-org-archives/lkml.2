Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab2DIFCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 01:02:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56049 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886Ab2DIFCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 01:02:32 -0400
Message-ID: <1333947749.4172.4.camel@joe2Laptop>
Subject: Re: [PATCH] dma: pl330: fix a couple of compilation warnings
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 08 Apr 2012 22:02:29 -0700
In-Reply-To: <CAOesGMgav3iqqNBtc1DccKKvRSpnNnDaCZmKBsdHj4feq-ns_A@mail.gmail.com>
References: <1333919920-25481-1-git-send-email-olof@lixom.net>
	 <1333921246.2508.8.camel@joe2Laptop>
	 <CAOesGMgav3iqqNBtc1DccKKvRSpnNnDaCZmKBsdHj4feq-ns_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 16:24 -0700, Olof Johansson wrote:
> On Sun, Apr 8, 2012 at 2:40 PM, Joe Perches <joe@perches.com> wrote:
> > On Sun, 2012-04-08 at 14:18 -0700, Olof Johansson wrote:
> >> Move a couple of tests and do a minor refactor to avoid:
> > []
> >> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > []
> >> @@ -2926,8 +2928,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
> >>       INIT_LIST_HEAD(&pd->channels);
> >>
> >>       /* Initialize channel parameters */
> >> -     num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
> >> -                     (u8)pi->pcfg.num_chan);
> >> +     num_chan = max_t(int, pdat ? pdat->nr_valid_peri :
> >> +                                  pi->pcfg.num_peri,
> >> +                           pi->pcfg.num_chan);
> >>       pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
> >
> > Few trivial things:
> >
> > There's no error checking for a malloc failure
> > This should probably be kcalloc
> 
> Yes, this driver could do with further cleanups, congratulations on
> your observations.
> 
> All of that is completely unrelated to this patch. Feel free to submit
> your own changes to clean up the driver further.

No thanks.  It's adjacent to the lines you modify
which is the only reason I noticed.  You might
also notice any patch I submit against the current
tree would conflict with your changes.

It'd be better if you actually fix problems with
the code and not simply make compiler warnings be
silenced when the problem is fundamentally that
the compiler is needs improvements.


