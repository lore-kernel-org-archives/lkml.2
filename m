Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2FNDKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:10:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15269 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2FNDKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:10:41 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-27-4fd9562f79de
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org, "'S, Venkatraman'" <svenkatr@ti.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>
References: <000601cd47ab$8ad77c50$a08674f0$%jun@samsung.com>
 <CANfBPZ9dwwAOBbXPqGV64k-sB-MzRtTO8x7tXnZBjtYN+V88XQ@mail.gmail.com>
 <000001cd489c$115f03b0$341d0b10$%jun@samsung.com>
 <113bb1f38dbc386f1adfc580e10dc2e5.squirrel@www.codeaurora.org>
 <CANfBPZ_+=keFgv-xDbzkZi2uVFvd46_JGoxweMKa1CvfX=X7=g@mail.gmail.com>
 <1476f0476a2dcfc6f7db9dbb4be0ab2b.squirrel@www.codeaurora.org>
In-reply-to: <1476f0476a2dcfc6f7db9dbb4be0ab2b.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v7 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Thu, 14 Jun 2012 12:10:38 +0900
Message-id: <003b01cd49db$4678a6b0$d369f410$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JrZC7P2lwc8O0T8+LcDteI+ZPcQALLFpw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAV39sJv+Bgs7JC0u75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkdW1YzFnTLVvT1+zQw/hTrYuTkkBAwkVgxYyEbhC0m
	ceHeeiCbi0NIYBGjRHfTZnYI5w+jRN/xmewgVWwCWhJ/37xhBrFFBOwkjt19BtbNLNDFKLH2
	TRBEQyOzxM0tJ8GKOAW8Ja48nMQCYgsL+Ejc2PwEzGYRUJWYsWgVWA2vgK3E/zlvGSFsQYkf
	k++xQAzVk/j45zYjhC0vsXnNW6B6DqBT1SUe/dWFuMFI4vizY8wQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCQ/qZ9A7GVQ0WhxgFOBiV
	eHiLAm76C7EmlhVX5h5ilOBgVhLhfaYAFOJNSaysSi3Kjy8qzUktPsQozcGiJM7bZH3BX0gg
	PbEkNTs1tSC1CCbLxMEp1cDo/eu87ZN4kfKDpzSOGM3g/id1Lb9Wp1ZSzSWEiSte8axilv9f
	G0lFiXrLlBSz/YHerHmXVmcZHBb67bTl8RztnrW6/+Izdm8qW958x/Vk6N1cxr2WLjtVvkxy
	eLVxOU/WqvxGP6+l1Sdmiebub/haI+138PnlmSYiASmc6256Wr+x/p3NFqTEUpyRaKjFXFSc
	CAAo0k00ZQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> On Wed, June 13, 2012 12:49 pm, S, Venkatraman wrote:
> > On Wed, Jun 13, 2012 at 12:45 AM,  <merez@codeaurora.org> wrote:
> >>
> >>> S, Venkatraman <svenkatr@ti.com> wrote:
> >>>> On Mon, Jun 11, 2012 at 1:53 PM, Seungwon Jeon <tgih.jun@samsung.com>
> >>>> wrote:
> >>>> > This patch adds packed command feature of eMMC4.5.
> >>>> > The maximum number for packing read(or write) is offered
> >>>> > and exception event relevant to packed command which is
> >>>> > used for error handling is enabled. If host wants to use
> >>>> > this feature, MMC_CAP2_PACKED_CMD should be set.
> >>>> >
> >>>> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> >>>>
> >>>> Can you please post some clear performance benchmarks with your
> >>>> patchset
> >>>> ?
> >>>> Given that #merez claims to see a significant performance drop for
> >>>> reads, it will be
> >>>> good to compare notes.
> >>>> If it's not too much trouble, both CFQ and deadline scheduler figures
> >>>> would be useful, on a
> >>>> set of read only, write only and parallel read write usecases.
> >>>>
> >>>> I can also try to replicate your results if you can publish the exact
> >>>> configuration you used
> >>>> for testing (example: iozone parameters)
> >>> I'm checking the merez's result.
> >>> Currently packed command is effective on write.
> >>> When running packed write with iozone, there is 25% performance gains.
> >>> (ex: iozone -az -i0 -I -s 10m -f /target/test -e)
> >>>
> >> Our tests shows performance gain of 50-60% in scenarios of only write
> >> lmdd
> >> operations.
> >>
> >> As I mentioned in the write packing control thread the degradation of
> >> read
> >> performance in case of mix read/write operations appears also without
> >> write packing. Therefore I don't think it should stop us from approving
> >> the write packing patch, that gives a significant improvement to the
> >> write
> >> performance.
> >> The read performance degradation should be resolved regardless of the
> >> write packing patch.
> >>
> >
> > One further question - when you say "degradation of read performance
> > in case of mix
> > read/write operations appears also without write packing", what
> > exactly does that mean?
> > Degradation w.r.to to read-only test ? Or any expected throughput ?
> 
> I meant w.r. to read only test.
> 
> >
> > If the scenario you mention is accurate, I was actually thinking that
> > we should recommend to merge
> > read packing first, then merge write packing once the read performance
> > issue is well understood.
> 
> I don't know if you followed the early discussion of this patch but the
> read throughput was not proved as efficient and in some of the cases it
> also caused degradation of the read performance. Therefore, we don't
> intend to merge it yet.
As I have mentioned in previous mailing, eMMC device which is tested with this patch
is not optimized for packed read. So currently it is difficult to ensure that
packed read is effective for performance. We need to test various vendor device
in regard to packed read.

Thanks,
Seungwon Jeon

> >
> > I am all for better performance with packing control etc, but the
> > overall code complexity is really
> > increasing more than necessary. I want to make sure that it is really
> > worth the effort.
> 
> In my opinion a gain of 50%-60% of the write performance worth the
> complexity of the code and the effort to fix the issues it reveals.
> 
> >
> > Thanks,
> > Venkat.
> >
> 
> 
> --
> Sent by consultant of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

