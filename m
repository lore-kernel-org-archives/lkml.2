Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2CMTej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:34:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9474 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270Ab2CMTeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:34:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="169830250"
Date: Tue, 13 Mar 2012 12:34:32 -0700
From: David Brown <davidb@codeaurora.org>
To: Shantanu Gupta <shans95g@gmail.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Ravi Kumar V <kumarrav@codeaurora.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
Message-ID: <20120313193432.GA13046@codeaurora.org>
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org>
 <20120312201421.GA3459@fifo99.com>
 <CAPDArRLs23VDJSWpX8xJsXfn+_SV2FcyzLYBF9UAxf=Rv9svGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDArRLs23VDJSWpX8xJsXfn+_SV2FcyzLYBF9UAxf=Rv9svGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 04:27:37PM +0530, Shantanu Gupta wrote:

> Any info available(publicly) on so as to what all chipsets have this capability
> ?

The ADM hardware is in every currently available MSM that can run
Linux.  It is being phased out, to be replaced by a new DMA system
(SPS/BAM).  Fortunately, there are some chips (MSM8960) that have both
ADM and SPS/BAM so there should be time to get those drivers in.

At least as my memory serves me:

  7201 - ADM
  8250 - ADM
  8660 - 2 ADMs, SPS/BAM
  8960 - 1 ADM, SPS/BAM

The ADM is mostly a regular DMA-type device.  Each channel can be
associated with a rate-control channel, which is needed for some
devices.  It also has a mode called "box mode", which works kind of
like a self-repeating scatter list.  This mode is needed for some of
the peripherals also on the MSM.

David

> On Tue, Mar 13, 2012 at 1:44 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> 
>     On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
>     > Add DMAEngine based driver using the old MSM DMA APIs internally.
> 
>     What do you mean by this?
> 
>     > The benefit of this approach is that not all the drivers
>     > have to get converted to DMAEngine APIs simultaneosly while
>     > both the drivers can stay enabled in the kernel. The client
>     > drivers using the old MSM APIs directly can now convert to
>     > DMAEngine one by one.
> 
>     Which drivers?
>    
>     Daniel
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
>     the body of a message to majordomo@vger.kernel.org
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
