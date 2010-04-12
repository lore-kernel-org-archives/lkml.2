Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0DLEue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 00:50:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:47796 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0DLEud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 00:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,187,1270450800"; 
   d="scan'208";a="612174490"
Date: Mon, 12 Apr 2010 12:50:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "drepper@gmail.com" <drepper@gmail.com>
Cc: Taras Glek <tglek@mozilla.com>, Johannes Weiner <hannes@cmpxchg.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-ID: <20100412045029.GA18099@localhost>
References: <20100412022704.GB5151@localhost> <g7wssj9j6ukus9yti3UYAxe124vaj_firegpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g7wssj9j6ukus9yti3UYAxe124vaj_firegpg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:43:00PM +0800, drepper@gmail.com wrote:
> On Sun, Apr 11, 2010 at 19:27, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> Yes, every binary/library starts with this 512b read.  It is requested
>> by ld.so/ld-linux.so, and will trigger a 4-page readahead. This is not
>> good readahead. I wonder if ld.so can switch to mmap read for the
>> first read, in order to trigger a larger 128kb readahead.
>
> We first need to know the sizes of the segments and their location
> in the binary.  The binaries we use now are somewhat well laid out.
> The read-only segment starts at offset 0 etc.  But this doesn't have
> to be the case.  The dynamic linker has to be generic.  Also, even
> if we start mapping at offset zero, now much to map?  The file might
> contain debug info which must not be mapped.  Therefore the first
> read loads enough of the headers to make all of the decisions.  Yes,

I once read the ld code, it's more complex than I expected.

> we could do a mmap of one page instead of the read.  But that's more
> expansive in general, isn't it?

Right. Without considering IO, a simple read(512) is more efficient than
mmap()+read+munmap().

Thanks,
Fengguang
