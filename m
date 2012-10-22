Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2JVUnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:43:13 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40996 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab2JVUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:43:11 -0400
X-Sasl-enc: uD5RhV6h4j61rmVgSDa45stA4+m4Ox+aGvm2tUGIc1su 1350938589
Date: Mon, 22 Oct 2012 13:43:08 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
Message-ID: <20121022204308.GA23993@kroah.com>
References: <1349916138-9011-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349916138-9011-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 05:42:18PM -0700, Nitin Gupta wrote:
> Change 130f315a (staging: zram: remove special handle of uncompressed page)
> introduced a bug in the handling of incompressible pages which resulted in
> memory allocation failure for such pages.
> 
> When a page expands on compression, say from 4K to 4K+30, we were trying to
> do zsmalloc(pool, 4K+30). However, the maximum size which zsmalloc can
> allocate is PAGE_SIZE (for obvious reasons), so such allocation requests
> always return failure (0).
> 
> For a page that has compressed size larger than the original size (this may
> happen with already compressed or random data), there is no point storing
> the compressed version as that would take more space and would also require
> time for decompression when needed again. So, the fix is to store any page,
> whose compressed size exceeds a threshold (max_zpage_size), as-it-is i.e.
> without compression.  Memory required for storing this uncompressed page can
> then be requested from zsmalloc which supports PAGE_SIZE sized allocations.
> 
> Lastly, the fix checks that we do not attempt to "decompress" the page which
> we stored in the uncompressed form -- we just memcpy() out such pages.

So this fix needs to go to the stable 3.6 release also, right?

thanks,

greg k-h
