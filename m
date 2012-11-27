Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2K0WZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 17:25:29 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45403 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2K0WZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 17:25:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121127213943.GB5100@linux.intel.com>
References: <CAMi7pMamJK079wQs+5Kaz=zdYGAPS+BFg2xCRKJMqPFMrQvQPQ@mail.gmail.com>
	<50B4AD8A.7020208@kernel.dk>
	<20121127170509.GA5100@linux.intel.com>
	<CAMi7pMb7Ln02hLfa_i-7ucWZBDGzQLUOoQTeFp70=yGix_gojA@mail.gmail.com>
	<20121127213943.GB5100@linux.intel.com>
Date: Tue, 27 Nov 2012 14:25:27 -0800
X-Google-Sender-Auth: rH6mpSitB492qqnQPJpl1CMFQRg
Message-ID: <CAMi7pMau=bOZ4ECPgteHT-NkfxU+oU0qZw+fFsjKfGQP_UscBw@mail.gmail.com>
Subject: Re: Alignment Issue with Direct IO to NVMe Drive
From: Laine Walker-Avina <lwalkera@ieee.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, lwalkera@micron.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 1:39 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Tue, Nov 27, 2012 at 09:47:48AM -0800, Laine Walker-Avina wrote:
>> On Tue, Nov 27, 2012 at 9:05 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
>> > Laine, when this occurs, what is the alignment of 'offset' in the sg
>> > entry you're looking at?  If userspace is passing in an unaligned address,
>> > I don't think there's anything we do to try to align it.
>>
>> I thought this was the case as well, but it appears to be aligned
>> looking at the request in the user space program (fio using libaio in
>> this case) before the IO is submitted.
>
> OK, so we have an aligned virtual address being translated into an
> unaligned DMA address.  I have a suspicion ... are you using the swiotlb,
> or are you using a real IOMMU?  Grep dmesg for 'IOMMU' if you're not sure.

There is no mention of IOMMU in dmesg on a fresh boot. The processor
in the test system I'm using is an i5-2400 (Sandy Bridge).

-Laine
