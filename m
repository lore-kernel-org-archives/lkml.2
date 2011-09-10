Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab1IJCle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:41:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50820 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1IJCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:41:33 -0400
Message-ID: <4E6ACE5B.9040401@vflare.org>
Date: Fri, 09 Sep 2011 22:41:31 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, dan.magenheimer@oracle.com,
        cascardo@holoscopio.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, linux-mm@kvack.org, brking@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com>
In-Reply-To: <20110909203447.GB19127@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 04:34 PM, Greg KH wrote:

> On Wed, Sep 07, 2011 at 09:09:04AM -0500, Seth Jennings wrote:
>> Changelog:
>> v2: fix bug in find_remove_block()
>>     fix whitespace warning at EOF
>>
>> This patchset introduces a new memory allocator for persistent
>> pages for zcache.  The current allocator is xvmalloc.  xvmalloc
>> has two notable limitations:
>> * High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
>> * No compaction support which reduces page reclaimation
> 
> I need some acks from other zcache developers before I can accept this.
> 

First, thanks for this new allocator; xvmalloc badly needed a replacement :)

I went through xcfmalloc in detail and would be posting detailed
comments tomorrow.  In general, it seems to be quite similar to the
"chunk based" allocator used in initial implementation of "compcache" --
please see section 2.3.1 in this paper:
http://www.linuxsymposium.org/archives/OLS/Reprints-2007/briglia-Reprint.pdf

I'm really looking forward to a slab based allocator as I mentioned in
the initial mail:
http://permalink.gmane.org/gmane.linux.kernel.mm/65467

With the current design xcfmalloc suffers from issues similar to the
allocator described in the paper:
 - High metadata overhead
 - Difficult implementation of compaction
 - Need for extra memcpy()s  etc.

With slab based approach, we can almost eliminate any metadata overhead,
remove any free chunk merging logic, simplify compaction and so on.

Thanks,
Nitin
