Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab1JNRMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:12:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:4901 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349Ab1JNRMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,347,1315206000"; 
   d="scan'208";a="62672866"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <CAJe_ZheL9EFNvPAU+shAjQG+mhOYQwXkdi1WpZ=kjn+0jWnuaw@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	 <1318599079.1546.395.camel@vkoul-udesk3>
	 <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
	 <1318604775.1546.418.camel@vkoul-udesk3>
	 <CAJe_ZheL9EFNvPAU+shAjQG+mhOYQwXkdi1WpZ=kjn+0jWnuaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 22:34:05 +0530
Message-ID: <1318611845.23438.3.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 22:05 +0530, Jassi Brar wrote:
> >> and some hardwares need two seperate dma channels to tranfer left
> and
> >> right audio channel.
> >>
> >> For 1st and 2nd dma channel, they want dma address increases 4bytes
> >> and transfer 2bytes every line.
> >> so it looks to me like a cyclic interleaved dma.
> > Hmmm, do we have sound cards which use this?
> > Nevertheless for this kind of transfers we would need interleaved
> cyclic
> > DMA as well, Do you have such usage? Can you tell me which codec
> > requires this?
> >
> My proposed 'frm_irq' and 'cyclic' flags are for such requirements.
> 
> Consider a 5.1chan I2S controller that employs 3 dma-channels
> each transferring 2 audio-channels to 3 three FIFOs. And the
> pcm-dma driver supports SNDRV_PCM_INFO_INTERLEAVED.
> While I worked with simple single fifo 5.1chan I2S controllers, I
> don't
> think such 3-fifo controllers can't exist. 
I am not against cyclic, and yes 3 fifos can exist but one would
question why we need 3 controller, 3 sets of ports and pins and
associated analog stuff when one can do with one :)

Nevertheless, cyclic should be supported for all dmaengine APIs (but not
adding new APIs for cyclic) and in consistent manner by having a generic
cyclic flag and caps.

-- 
~Vinod

