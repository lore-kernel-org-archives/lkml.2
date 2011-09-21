Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab1IUGgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:36:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:57359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1IUGgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:36:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,415,1312182000"; 
   d="scan'208";a="53882959"
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
In-Reply-To: <CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	 <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	 <1316537529.31295.14.camel@vkoul-udesk3>
	 <CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 12:02:03 +0530
Message-ID: <1316586723.1573.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 23:38 +0530, Jassi Brar wrote:
> On 20 September 2011 22:22, Vinod Koul <vinod.koul@intel.com> wrote:
> > Also for slave transfers, how do we infer direction?
> I already explained to Barry.  Here's it again.
> 
> At any time, the dmac driver knows if the channel, on which the xfer is
> prepared/submitted is Slave or not.
> 
> SLAVE Transfer
>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE
> 
> Mem->Mem Transfer
>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => Meaningless
>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => MemSet
Rather than each driver adding this logic with good chance of screwing
up, care to add this as helper in dmaengine.h

Ideally, I would have preferred direction to be told explicitly, would
leave it you..

-- 
~Vinod

