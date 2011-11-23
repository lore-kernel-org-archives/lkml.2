Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1KWLEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:04:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:47616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1KWLEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:04:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,558,1315206000"; 
   d="scan'208";a="94495483"
Subject: RE: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 access empty list
From: Vinod Koul <vinod.koul@intel.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
	 <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
	 <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 16:30:34 +0530
Message-ID: <1322046034.1516.254.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 14:26 -0600, H Hartley Sweeten wrote:
> On Tuesday, November 22, 2011 12:46 PM, Mika Westerberg wrote:
> > From: Rafal Prylowski <prylowski@metasoft.pl>
> >
> > If dma_terminate_all() is called before the ep93xx_dma_tasklet()
> gets to run,
> > it tries to access an empty ->active list causing following OOPS:
> 
> [snip]
> 
> > As we expect that the ->active list is never empty when the
> ep93xx_dma_tasklet()
> > is called, we fix this by adding a new flag per channel
> EP93XX_DMA_IS_RUNNING
> > which determines whether the channel is running or not.
> > 
> > We also add BUG_ON() to ep93xx_dma_get_active() to make sure that
> similar
> > problems will be caught early. 
My $0.02

will you still hit the problem if you do a proper check in tasklet for 
a) if list is empty
b) if _get_active_desc() returns valid desc
and the _get_active_desc() returns NULL on not finding active desc

The point is by adding a flag you are avoiding the condition hence it is
working for you whereas on other approach you exit gracefully without
crashing in all the cases (including potentially uncovered ones)


-- 
~Vinod

