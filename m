Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1JNO0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:26:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48378 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab1JNO0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,346,1315206000"; 
   d="scan'208";a="78151614"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <1318601113.1546.409.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	 <1318599079.1546.395.camel@vkoul-udesk3>
	 <CAJe_ZheA3iTQ2K4aCYccn2N_8fkMkLMPV9MbQG6gHjYWiKdOCQ@mail.gmail.com>
	 <1318601113.1546.409.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 19:48:29 +0530
Message-ID: <1318601909.1546.410.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 19:35 +0530, Vinod Koul wrote:
> On Fri, 2011-10-14 at 19:21 +0530, Jassi Brar wrote:
> > >> ... we need to restore 'bool frm_irq' and add new 'bool cyclic' that
> > >> would replay the transfer(i.e, reset dma-pointers to src_start & dst_start)
> > >> after 'numf' frames have been transferred.
> > > I was thinking more on lines to have this conveyed thru a flag.
> > >
> > Sorry don't see exactly what you mean.
> > frm_irq and numf are independent of each other and could
> > cover more cases than a single flag.
> > 
> > > Anyway I plan to work on merging device_prep_slave_sg and
> > > device_prep_cyclic to single API. Think more of device_prep_cyclic as
> > > special case with sg length one and flag to tell dmac its cyclic.
> > >
> > AFAIK, usually the ring buffer is divided into N (>1) different
> > periods that need
> > to be transferred in endless loop.
> But that is not interleaved dma, we have a cyclic API, barry should be
> using that
> > 
> > > Similarly here we could use/define this flag to say this transfer is
> > > also cyclic in nature and dmac then reloads the list again.
> > > That way any prep can be made cyclic in nature by just using this flag.
> > >
> > Some cyclic transfers might want callback done after each period/frame
> > while some not. We can't cover using just one flag.
> Again, we would typically have two cases:
> 1) notification at end of each list
> 2) notification at end of each frame and complete list
> If we use ACK flag along with callback field we can achieve above by
> defining rules as 
> - if callback is set, notify after list completion (this is set in
> descriptor for this purpose)
> - if ACK is set, then call for each frame as well
> If we agree then, we should add this info to documentation and fix
> existing behavior
Sorry meant DMA_PREP_INTERRUPT flag above :)


-- 
~Vinod

