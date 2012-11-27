Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2K0Rne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:43:34 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45301 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab2K0Rnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <50B4AD8A.7020208@kernel.dk>
References: <CAMi7pMamJK079wQs+5Kaz=zdYGAPS+BFg2xCRKJMqPFMrQvQPQ@mail.gmail.com>
	<50B4AD8A.7020208@kernel.dk>
Date: Tue, 27 Nov 2012 09:43:32 -0800
X-Google-Sender-Auth: jFKLMRY0ZoNKO8NVRsPcbdpM1gY
Message-ID: <CAMi7pMYGyOW32PrLmMM8C+jJQ-NjGUjn6wUk00O1BdO4=f5YTw@mail.gmail.com>
Subject: Re: Alignment Issue with Direct IO to NVMe Drive
From: Laine Walker-Avina <lwalkera@ieee.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        willy@linux.intel.com, lwalkera@micron.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 4:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-11-27 01:35, Laine Walker-Avina wrote:
>> Hi all,
>>
>> We are experiencing an issue with doing direct IO to a NVMe device I'm
>> helping to develop. Every so often, the physical address given by
>> sg_dma_address() is aligned to 0x800 instead of 0x1000 as specified by
>> blk_queue_dma_alignement(queue, 4095) when the queue is initialized.
>> The request is also split over multiple segments to make up for the
>> missing space (eg: for a 4k IO it's split into two segments 2k in
>> size, and for an 8k IO it's split into 3 segments--2k,4k,2k). Our
>> design requires the physical segments given to the device be aligned
>> to 4k boundaries and be multiples of 4k in size. When not doing direct
>> IO the physical addresses appear to always be 4k aligned as expected.
>> One possible issue is the kernel we're primarily testing against is
>> 2.6.32-220 from CentOS, but we have observed similar behavior from a
>> vanilla 3.3 kernel as well. Any help would be greatly appreciated.
>
> I'm assuming you set the hardware sector size to 4k as well?
>
> --
> Jens Axboe
>

Yes, as well as the logical block size and io_min.

Laine Walker-Avina
