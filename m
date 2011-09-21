Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1IUGz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:55:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:22328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1IUGz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:55:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,415,1312182000"; 
   d="scan'208";a="56049755"
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
In-Reply-To: <CAJe_Zhc67VR-+YAYaLhbwOF=eo2s7wOkjwvi+kJ5=bGt-YWmqA@mail.gmail.com>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	 <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	 <1316537529.31295.14.camel@vkoul-udesk3>
	 <CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
	 <1316586723.1573.4.camel@vkoul-udesk3>
	 <CAJe_Zhc67VR-+YAYaLhbwOF=eo2s7wOkjwvi+kJ5=bGt-YWmqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 12:21:43 +0530
Message-ID: <1316587903.1573.8.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 12:15 +0530, Jassi Brar wrote:
> On 21 September 2011 12:02, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, 2011-09-20 at 23:38 +0530, Jassi Brar wrote:
> >> On 20 September 2011 22:22, Vinod Koul <vinod.koul@intel.com> wrote:
> >> > Also for slave transfers, how do we infer direction?
> >> I already explained to Barry.  Here's it again.
> >>
> >> At any time, the dmac driver knows if the channel, on which the xfer is
> >> prepared/submitted is Slave or not.
> >>
> >> SLAVE Transfer
> >>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
> >>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE
> >>
> >> Mem->Mem Transfer
> >>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => Meaningless
> >>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => MemSet
> > Rather than each driver adding this logic with good chance of screwing
> > up, care to add this as helper in dmaengine.h
> >
> > Ideally, I would have preferred direction to be told explicitly, would
> > leave it you..
> >
> I repeat yet again :- "This api is common to Slave as well as Mem<->Mem"
> 
> Even if we have slave clients specify DMA_TO/FROM_DEVICE, what
> flag do you suggest Mem->Mem clients use ?
Would it be invalid in that case!!! Same as few ields in xt_template
would be for peripheral case..

-- 
~Vinod

