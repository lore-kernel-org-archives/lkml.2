Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2JVVsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:48:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37642 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2JVVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <20121022204308.GA23993@kroah.com>
References: <1349916138-9011-1-git-send-email-ngupta@vflare.org>
	<20121022204308.GA23993@kroah.com>
Date: Mon, 22 Oct 2012 14:48:03 -0700
Message-ID: <CAPkvG_eVF-ZiwLr=i9gRodqfrSuehSoMOAL9hkpUBtOFRXE8LQ@mail.gmail.com>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 1:43 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Oct 10, 2012 at 05:42:18PM -0700, Nitin Gupta wrote:
>> Change 130f315a (staging: zram: remove special handle of uncompressed page)
>> introduced a bug in the handling of incompressible pages which resulted in
>> memory allocation failure for such pages.
>>
>> When a page expands on compression, say from 4K to 4K+30, we were trying to
>> do zsmalloc(pool, 4K+30). However, the maximum size which zsmalloc can
>> allocate is PAGE_SIZE (for obvious reasons), so such allocation requests
>> always return failure (0).
>>
>> For a page that has compressed size larger than the original size (this may
>> happen with already compressed or random data), there is no point storing
>> the compressed version as that would take more space and would also require
>> time for decompression when needed again. So, the fix is to store any page,
>> whose compressed size exceeds a threshold (max_zpage_size), as-it-is i.e.
>> without compression.  Memory required for storing this uncompressed page can
>> then be requested from zsmalloc which supports PAGE_SIZE sized allocations.
>>
>> Lastly, the fix checks that we do not attempt to "decompress" the page which
>> we stored in the uncompressed form -- we just memcpy() out such pages.
>
> So this fix needs to go to the stable 3.6 release also, right?
>

Forgot to mention -- yes, this needs to be in 3.6 also.

Thanks,
Nitin
