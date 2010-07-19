Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966629Ab0GST7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:59:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39854 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966485Ab0GST7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:59:43 -0400
MIME-Version: 1.0
Message-ID: <4f986c65-c17e-47d8-9c30-60cd17809cbb@default>
Date: Mon, 19 Jul 2010 12:57:24 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/8] zcache: page cache compression support
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44AE3C.0271:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We only keep pages that compress to PAGE_SIZE/2 or less. Compressed
> chunks are
> stored using xvmalloc memory allocator which is already being used by
> zram
> driver for the same purpose. Zero-filled pages are checked and no
> memory is
> allocated for them.

I'm curious about this policy choice.  I can see why one
would want to ensure that the average page is compressed
to less than PAGE_SIZE/2, and preferably PAGE_SIZE/2
minus the overhead of the data structures necessary to
track the page.  And I see that this makes no difference
when the reclamation algorithm is random (as it is for
now).  But once there is some better reclamation logic,
I'd hope that this compression factor restriction would
be lifted and replaced with something much higher.  IIRC,
compression is much more expensive than decompression
so there's no CPU-overhead argument here either,
correct?

Thanks,
Dan
