Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2JDPt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:49:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:61304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2JDPt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:49:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,535,1344236400"; 
   d="scan'208";a="200573705"
Message-ID: <506DB02A.2030901@intel.com>
Date: Thu, 04 Oct 2012 08:50:02 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical
 addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <20121004125546.GA9158@phenom.dumpdata.com>
In-Reply-To: <20121004125546.GA9158@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 05:55 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 03, 2012 at 05:38:41PM -0700, Alexander Duyck wrote:
>> While working on 10Gb/s routing performance I found a significant amount of
>> time was being spent in the swiotlb DMA handler.  Further digging found that a
>> significant amount of this was due to the fact that virtual to physical
>> address translation and calling the function that did it.  It accounted for
>> nearly 60% of the total overhead.
>>
>> This patch set works to resolve that by changing the io_tlb_start address and
>> io_tlb_overflow_buffer address from virtual addresses to physical addresses.
>> By doing this, devices that are not making use of bounce buffers can
>> significantly reduce their overhead.  In addition I followed through with the
> .. but are still using SWIOTLB for their DMA operations, right?
>

That is correct.  I tested with the bounce buffers in use as well, but
didn't really see any difference since almost all of the overhead was
due to the locking required in obtaining and releasing the bounce
buffers in map/unmap calls.

Thanks,

Alex
