Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1IUHb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:31:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51970 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1IUHbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <1316587903.1573.8.camel@vkoul-udesk3>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1316537529.31295.14.camel@vkoul-udesk3>
	<CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
	<1316586723.1573.4.camel@vkoul-udesk3>
	<CAJe_Zhc67VR-+YAYaLhbwOF=eo2s7wOkjwvi+kJ5=bGt-YWmqA@mail.gmail.com>
	<1316587903.1573.8.camel@vkoul-udesk3>
Date: Wed, 21 Sep 2011 13:01:24 +0530
Message-ID: <CAJe_ZheO7e0Ft364io86aqnShK11XMTj+iC5eeU_zVCY0fJghw@mail.gmail.com>
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 September 2011 12:21, Vinod Koul <vinod.koul@intel.com> wrote:
>> >> > Also for slave transfers, how do we infer direction?
>> >> I already explained to Barry.  Here's it again.
>> >>
>> >> At any time, the dmac driver knows if the channel, on which the xfer is
>> >> prepared/submitted is Slave or not.
>> >>
>> >> SLAVE Transfer
>> >>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
>> >>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE
>> >>
>> >> Mem->Mem Transfer
>> >>    dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => Meaningless
>> >>    !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => MemSet
>> > Rather than each driver adding this logic with good chance of screwing
>> > up, care to add this as helper in dmaengine.h
>> >
>> > Ideally, I would have preferred direction to be told explicitly, would
>> > leave it you..
>> >
>> I repeat yet again :- "This api is common to Slave as well as Mem<->Mem"
>>
>> Even if we have slave clients specify DMA_TO/FROM_DEVICE, what
>> flag do you suggest Mem->Mem clients use ?
> Would it be invalid in that case!!!
Of course!
It doesn't make any sense for a mem->mem client asking
for DMA_FROM_DEVICE when it wanted MemSet.

> Same as few ields in xt_template would be for peripheral case..
No properly written client would ever pass 'invalid' values for
xt_template members.
But _every_ properly written Mem->Mem client would have to
ask for DMA_TO/FROM_DEVICE, following what you suggest.

Btw, even if we wanted, Memcpy couldn't be represented by
either DMA_TO_DEVICE or  DMA_FROM_DEVICE, because
both Src and Dst increments here.
