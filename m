Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab1JGOZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:25:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:52429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab1JGOZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:25:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="60915677"
Subject: Re: [PATCH] pch_dma: Fix suspend issue
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <4E8ED574.8040609@dsn.lapis-semi.com>
References: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	 <1317963658.1573.2229.camel@vkoul-udesk3>
	 <4E8E940E.7040701@dsn.lapis-semi.com>
	 <1317968080.1573.2266.camel@vkoul-udesk3>
	 <4E8ED574.8040609@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 19:48:05 +0530
Message-ID: <1317997085.1573.2273.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 19:33 +0900, Tomoya MORINAGA wrote:
> (2011/10/07 15:14), Vinod Koul wrote:
> > This is all is due to not saving nr_channels in probe and using that
> > instead.
> >
> > Looking deeper, struct pch_dma defines array of length MAX_CHAN_NR for
> > channels. Then why do you allocate memory in probe as
> >           pd = kzalloc(sizeof(struct pch_dma)+
> >                   sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
> > what is the point in allocating additional memory for each channel?
> >
> > Given this, why should there be predefined channel array in pcm_dma?
> >
> > It would be great if we could fix this by dynamically allocating memory
> > for channels based on nr_channels and not wasting due to a static array.
> 
> You are right.
> Current pch_dma driver looks like wasting memory.
> 
> We must review pch_dma driver again.
Okay, can you update the changelog to indicate how it is fixing the
suspend issue, original change log doesn't help


-- 
~Vinod

