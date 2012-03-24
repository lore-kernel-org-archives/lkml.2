Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2CXHdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:33:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54882 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2CXHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:33:03 -0400
Date: Sat, 24 Mar 2012 09:32:07 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120324073207.GD5812@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
 <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net>
 <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 11:09:50AM -0500, H Hartley Sweeten wrote:
> On Friday, March 23, 2012 12:05 AM, Mika Westerberg wrote:
> > On Thu, Mar 22, 2012 at 09:19:10PM -0500, H Hartley Sweeten wrote:
> >
> >> Did you test this patch or just review it?
> >
> > I tested and reviewed it.
> 
> OK. What kernel? My tests so far have been with 3.3.

3.3 and -next.

> >> On my system it doesn't work. I think it has something to do with the
> >> changes to m2m_hw_interrupt but I haven't tracked it down yet.
> >> 
> >> It looks like what's missing is a:
> >> 
> >> 	edmac->edma->hw_submit(edmac);
> >> 
> >> But, maybe that's not needed with double buffering?
> >
> > Did you try without your patch and adding my VIC hack? That's what I did when
> > I first got this patch and I saw no problems. I tested with audio (M2P),
> > mmc_spi (M2M) and dmatest (M2M).
> 
> No, I have not applied your VIC hack.

Please try it. The point there was that we have a problem in ep93xx VIC/DMA
code but it is totally different thing and not related to Rafal's patch. We
can sort the VIC thing out separately IMHO. ep93xx dma in 3.3 is broken
regardless this patch.
