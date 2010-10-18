Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0JROAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:00:17 -0400
Received: from emroute3.ornl.gov ([160.91.4.110]:44644 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0JROAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:00:15 -0400
X-Greylist: delayed 3133 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 10:00:15 EDT
Date: Mon, 18 Oct 2010 09:08:00 -0400
From: David Dillow <dillowda@ornl.gov>
Subject: Re: DMA sync question
In-reply-to: <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "rolandd@cisco.com" <rolandd@cisco.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Message-id: <1287407280.10438.44.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
 <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
 <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 06:11 -0400, Bart Van Assche wrote:
> On Sun, Oct 17, 2010 at 5:25 AM, David Dillow <dillowda@ornl.gov> wrote:
> > [ ... ]
> > +static int srp_response_common(struct srp_target_port *target, s32 req_delta,
> > +                              void *rsp, int len)
[ ... ]
> > +
> > +       ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
> > +       memcpy(iu->buf, rsp, len);
> > +       ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
> > [ ... ]

> Hi Dave,
> 
> As far as I can see the above sync call applies to a buffer in the
> tx_ring[]. Data in that buffer is only modified by the CPU and never
> by the HCA. So why is the above sync call present ? Is that call
> necessary ?

In this instance, I copied existing practice from srp_queuecommand().

Documentation/DMA-API.txt seems to indicate we don't need the initial
*_sync_for_cpu() since the device never writes to the buffer, but I seem
to have an old memory that says we should do it anyways.

Perhaps LKML can clear it up -- do we need to call *_sync_for_cpu()
after a *sync_for_device(), even if the device never writes to the
buffer?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


