Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1H3KDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:03:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:58845 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1H3KDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:03:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,301,1312182000"; 
   d="scan'208";a="46377422"
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
	 <1308916071.1536.4.camel@vkoul-udesk3>
	 <20110829080047.GJ31809@linux-sh.org>
	 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
	 <1314618931.1606.114.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 15:32:02 +0530
Message-ID: <1314698522.1606.164.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 09:54 +0200, Guennadi Liakhovetski wrote:
> On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > >> You should not assign chan->private.
> > > >> Please move this  to dma_slave_control API
> > > >
> > > > I haven't seen any reply to this comment and this patch seems to still be
> > > > outstanding, is there an updated version of this patch that I've missed?
> > I don't recall seeing any updated version fixing this 
> 
> As a matter of fact, when you say "use dma_slave_control API," you 
> actually mean the dma_slave_config, right? Then, how is one supposed to 
> use it in this case? Shall we be issuing a DMA_SLAVE_CONFIG call inside of 
> the filter and check the return code? The problem is, that not all DMA 
> controllers on sh-mobile SoCs can service the same slave devices. So, if 
> we don't check in the filter we might well get an unsuitable DMA channel.
Here you are assigning to chan->private your specific values, which
should be moved to the dma_slave_config. 
But here you are removing the checks, and accepting the first channel
you got, so how do you find channel is suitable or not.

-- 
~Vinod

