Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1JNNvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:51:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab1JNNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <1318599079.1546.395.camel@vkoul-udesk3>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1318489410-3182-1-git-send-email-jaswinder.singh@linaro.org>
	<CAGsJ_4yqdwaTxi=KMcgokb05uWUNi5_7uZDGqA4RsOZkWZ7FQA@mail.gmail.com>
	<CAJe_ZhfomhARd8EVcR+jCHuFLrAKkNqvaETFHiNtNeijx+5Kxw@mail.gmail.com>
	<1318599079.1546.395.camel@vkoul-udesk3>
Date: Fri, 14 Oct 2011 19:21:45 +0530
Message-ID: <CAJe_ZheA3iTQ2K4aCYccn2N_8fkMkLMPV9MbQG6gHjYWiKdOCQ@mail.gmail.com>
Subject: Re: [PATCHv5] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, rmk@arm.linux.org.uk,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2011 19:01, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, 2011-10-14 at 17:21 +0530, Jassi Brar wrote:
>> On 14 October 2011 13:02, Barry Song <21cnbao@gmail.com> wrote:
>> >
>> > what if i want a cyclic interleaved transfer? i think the cyclic
>> > interleaved transfer is what i want for audio dma.
>> >
>> ... we need to restore 'bool frm_irq' and add new 'bool cyclic' that
>> would replay the transfer(i.e, reset dma-pointers to src_start & dst_start)
>> after 'numf' frames have been transferred.
> I was thinking more on lines to have this conveyed thru a flag.
>
Sorry don't see exactly what you mean.
frm_irq and numf are independent of each other and could
cover more cases than a single flag.

> Anyway I plan to work on merging device_prep_slave_sg and
> device_prep_cyclic to single API. Think more of device_prep_cyclic as
> special case with sg length one and flag to tell dmac its cyclic.
>
AFAIK, usually the ring buffer is divided into N (>1) different
periods that need
to be transferred in endless loop.

> Similarly here we could use/define this flag to say this transfer is
> also cyclic in nature and dmac then reloads the list again.
> That way any prep can be made cyclic in nature by just using this flag.
>
Some cyclic transfers might want callback done after each period/frame
while some not. We can't cover using just one flag.
