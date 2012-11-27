Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2K0AfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:35:18 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58046 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2K0AfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:35:16 -0500
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 16:35:15 -0800
X-Google-Sender-Auth: VYS0AoxCXr--fm_5A3L4J5xM3I8
Message-ID: <CAMi7pMamJK079wQs+5Kaz=zdYGAPS+BFg2xCRKJMqPFMrQvQPQ@mail.gmail.com>
Subject: Alignment Issue with Direct IO to NVMe Drive
From: Laine Walker-Avina <lwalkera@ieee.org>
To: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Cc: lwalkera@micron.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We are experiencing an issue with doing direct IO to a NVMe device I'm
helping to develop. Every so often, the physical address given by
sg_dma_address() is aligned to 0x800 instead of 0x1000 as specified by
blk_queue_dma_alignement(queue, 4095) when the queue is initialized.
The request is also split over multiple segments to make up for the
missing space (eg: for a 4k IO it's split into two segments 2k in
size, and for an 8k IO it's split into 3 segments--2k,4k,2k). Our
design requires the physical segments given to the device be aligned
to 4k boundaries and be multiples of 4k in size. When not doing direct
IO the physical addresses appear to always be 4k aligned as expected.
One possible issue is the kernel we're primarily testing against is
2.6.32-220 from CentOS, but we have observed similar behavior from a
vanilla 3.3 kernel as well. Any help would be greatly appreciated.

Thanks,
Laine Walker-Avina
