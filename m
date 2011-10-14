Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab1JNPOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:14:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:12772 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147Ab1JNPOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:14:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62992221"
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
In-Reply-To: <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	 <1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	 <CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	 <CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	 <1318599079.1546.395.camel@vkoul-udesk3>
	 <CAGsJ_4zSKwSm-En0TCacMTPhRG_YCaOC=aWcxF7rXWq26JcKuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 20:36:15 +0530
Message-ID: <1318604775.1546.418.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 22:55 +0800, Barry Song wrote:
> Hi Vinod,
> 
> 2011/10/14 Vinod Koul <vinod.koul@intel.com>:
> > On Fri, 2011-10-14 at 17:21 +0530, Jassi Brar wrote:
> >> On 14 October 2011 13:02, Barry Song <21cnbao@gmail.com> wrote:
> >> >
> >> > what if i want a cyclic interleaved transfer? i think the cyclic
> >> > interleaved transfer is what i want for audio dma.
> >> >
> >> ... we need to restore 'bool frm_irq' and add new 'bool cyclic' that
> >> would replay the transfer(i.e, reset dma-pointers to src_start & dst_start)
> >> after 'numf' frames have been transferred.
> > I was thinking more on lines to have this conveyed thru a flag.
> >
> > Anyway I plan to work on merging device_prep_slave_sg and
> > device_prep_cyclic to single API. Think more of device_prep_cyclic as
> > special case with sg length one and flag to tell dmac its cyclic.
> >
> > Similarly here we could use/define this flag to say this transfer is
> > also cyclic in nature and dmac then reloads the list again.
> > That way any prep can be made cyclic in nature by just using this flag.
> >
> > @Barry: Why would you need to use interleaved API for audio?
> 
> At first, audio dma is typically cyclic. if no underflow and overflow
> happens, it will always be running. underflow and overflow will
> trigger the cyclic dma termination.
Yes and you terminate dma. Then prepare will be called again and you
setup DMA again and on trigger start you start DMA again.
No need for interleaving in this case.
> 
> in case audio PCM data is interleaved and saved in dma buffer  as below:
> 
> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
> left (2B)  right (2B)
> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
> left (2B)  right (2B)
> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
> left (2B)  right (2B)
> left (2B)  right (2B)  left (2B)  right (2B)   left (2B)  right (2B)
> left (2B)  right (2B)
> ,,,,
> 
> and some hardwares need two seperate dma channels to tranfer left and
> right audio channel.
> 
> For 1st and 2nd dma channel, they want dma address increases 4bytes
> and transfer 2bytes every line.
> so it looks to me like a cyclic interleaved dma.
Hmmm, do we have sound cards which use this?
Nevertheless for this kind of transfers we would need interleaved cyclic
DMA as well, Do you have such usage? Can you tell me which codec
requires this?


-- 
~Vinod

