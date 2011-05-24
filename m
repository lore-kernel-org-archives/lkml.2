Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1EXQjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:39:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:51295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1EXQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:39:36 -0400
X-ExtLoop1: 1
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>
In-Reply-To: <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	 <BANLkTikDPeEFWdsVQ=Ak8jXEXsC-+uoOaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 21:36:11 +0530
Message-ID: <1306253171.30236.9.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 17:40 +0200, Per Forlin wrote:
> Hi Vinod,
> 
> On Tue, May 24, 2011 at 2:04 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
> > From: Vinod Koul <vinod.koul@intel.com>
> >
> > Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> > ---
> >  Documentation/dma-slave-api.txt |   74 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 74 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/dma-slave-api.txt
> I suggest putting this in subsection of dmaengine.txt instead.
> dmaengine.txt would be the natural place to look at.
Agreed, that would make it easier for people to find

> > +4. Submit the transaction(s) and wait for callback notification when slave API
> > +is 3 above returns, the non NULL value would imply a "descriptor" for the
> > +transaction. These transaction(s) would need to be submitted which pushes them
> > +into queue in DMA driver. If DMA is idle then the first descriptor submit will
> > +be pushed to DMA and subsequent ones will be queued. On completion of the DMA
> > +operation the next in queue is submitted and a tasklet triggered. The tasklet
> > +would then call the client driver completion callback routine for notification,
> > +if set.
> > +
> Does submit really start the transfer as well? My interpretation of
> submit is that is only adds desc to a pending queue. When calling
> issue_pending all these descs will be schedule for DMA transfer. Calls
> to submit after this point will added to the pending queue again and
> not be issued until calling issue_pending once more.
For slave dma devices, submit() is used to start the transaction if the
channel is idle. If its already doing a transaction then it will queue
it up and submit once cureent excuting one is completed. It is not
required to call issue_pending once more.
I am not sure if this is true for non slave usage, Dan would that be
correct for you as well?

-- 
~Vinod

