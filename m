Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1H3J64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:58:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:33975 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1H3J6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:58:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,301,1312182000"; 
   d="scan'208";a="12399509"
Subject: Re: [PATCH] dma: shdma: transfer based runtime PM
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
References: <Pine.LNX.4.64.1108181650530.5245@axis700.grange>
	 <1314282386.1606.42.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251636190.17190@axis700.grange>
	 <1314283286.1606.52.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108251648100.17190@axis700.grange>
	 <1314292850.1606.88.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108260107550.17190@axis700.grange>
	 <1314619909.1606.130.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108291419410.31184@axis700.grange>
	 <1314622113.1606.134.camel@vkoul-udesk3>
	 <Pine.LNX.4.64.1108300906590.19151@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 15:27:37 +0530
Message-ID: <1314698257.1606.159.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 09:12 +0200, Guennadi Liakhovetski wrote:
> On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > > Something like:
> > > > /* since callback is set for last descriptor of chain, we call runtime
> > > >  * put for that desc alone
> > > >  */
> > > > list_for_each_entry_safe(desc, __desc, sh_chan->ld_queue, node) {
> > > > 	if (desc->async_tx.callback)
> > > > 		pm_runtime_put(device);
> > > 
> > > Not all dma users have callbacks.
> > Do you have such usage today, at least I dont :)
> > Nevertheless, in tx_submit adding a simple flag in your drivers
> > descriptor structure can tell you whether to call _put() or not. Agreed?
> 
> Yes, I agree, that one could make this work too. Still, I do not 
> understand how and why this is better to the extent, that I have to 
> reimplement my patch, retest and resubmit it. Maybe Dan or Paul have an 
> opinion on this?
But wont it make code look simpler and cleaner, you don't reply on your
counters but on pm_runtime infrastructure to do the job. You juts need
to call _put/_get at right places, which IMO l;ooks lot simpler than
current approach

-- 
~Vinod

