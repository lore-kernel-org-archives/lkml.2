Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2FMTuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:50:21 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:43970 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab2FMTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <113bb1f38dbc386f1adfc580e10dc2e5.squirrel@www.codeaurora.org>
References: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
 <CANfBPZ9dwwAOBbXPqGV64k-sB-MzRtTO8x7tXnZBjtYN+V88XQ@mail.gmail.com>
 <000001cd489c$115f03b0$341d0b10$%jun@samsung.com> <113bb1f38dbc386f1adfc580e10dc2e5.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Thu, 14 Jun 2012 01:19:56 +0530
Message-ID: <CANfBPZ_+=keFgv-xDbzkZi2uVFvd46_JGoxweMKa1CvfX=X7=g@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mmc: core: Add packed command feature of eMMC4.5
To: merez@codeaurora.org
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:45 AM,  <merez@codeaurora.org> wrote:
>
>> S, Venkatraman <svenkatr@ti.com> wrote:
>>> On Mon, Jun 11, 2012 at 1:53 PM, Seungwon Jeon <tgih.jun@samsung.com>
>>> wrote:
>>> > This patch adds packed command feature of eMMC4.5.
>>> > The maximum number for packing read(or write) is offered
>>> > and exception event relevant to packed command which is
>>> > used for error handling is enabled. If host wants to use
>>> > this feature, MMC_CAP2_PACKED_CMD should be set.
>>> >
>>> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>>
>>> Can you please post some clear performance benchmarks with your patchset
>>> ?
>>> Given that #merez claims to see a significant performance drop for
>>> reads, it will be
>>> good to compare notes.
>>> If it's not too much trouble, both CFQ and deadline scheduler figures
>>> would be useful, on a
>>> set of read only, write only and parallel read write usecases.
>>>
>>> I can also try to replicate your results if you can publish the exact
>>> configuration you used
>>> for testing (example: iozone parameters)
>> I'm checking the merez's result.
>> Currently packed command is effective on write.
>> When running packed write with iozone, there is 25% performance gains.
>> (ex: iozone -az -i0 -I -s 10m -f /target/test -e)
>>
> Our tests shows performance gain of 50-60% in scenarios of only write lmdd
> operations.
>
> As I mentioned in the write packing control thread the degradation of read
> performance in case of mix read/write operations appears also without
> write packing. Therefore I don't think it should stop us from approving
> the write packing patch, that gives a significant improvement to the write
> performance.
> The read performance degradation should be resolved regardless of the
> write packing patch.
>

One further question - when you say "degradation of read performance
in case of mix
read/write operations appears also without write packing", what
exactly does that mean?
Degradation w.r.to to read-only test ? Or any expected throughput ?

If the scenario you mention is accurate, I was actually thinking that
we should recommend to merge
read packing first, then merge write packing once the read performance
issue is well understood.

I am all for better performance with packing control etc, but the
overall code complexity is really
increasing more than necessary. I want to make sure that it is really
worth the effort.

Thanks,
Venkat.
