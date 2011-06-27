Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1F0HHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:07:51 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:60549 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab1F0HF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:05:57 -0400
Date: Mon, 27 Jun 2011 09:05:52 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] fadvise: implement POSIX_FADV_NOREUSE
Message-ID: <20110627070552.GA1790@thinkpad>
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
 <1308923350-7932-3-git-send-email-andrea@betterlinux.com>
 <4E07B709.9010306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E07B709.9010306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 06:47:37PM -0400, Rik van Riel wrote:
> On 06/24/2011 09:49 AM, Andrea Righi wrote:
> 
> >@@ -114,7 +114,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
> >  			ret = 0;
> >  		break;
> >  	case POSIX_FADV_NOREUSE:
> >-		break;
> >+		/* Reduce cache eligibility */
> >+		force = false;
> >  	case POSIX_FADV_DONTNEED:
> >  		if (!bdi_write_congested(mapping->backing_dev_info))
> >  			filemap_flush(mapping);
> 
> And the same is true here.  "force" is just not a very
> descriptive name.

OK, I'll change the name to "invalidate" in the next version of the
patch.

Thanks,
-Andrea

> 
> >@@ -124,8 +125,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
> >  		end_index = (endbyte>>  PAGE_CACHE_SHIFT);
> >
> >  		if (end_index>= start_index)
> >-			invalidate_mapping_pages(mapping, start_index,
> >-						end_index);
> >+			__invalidate_mapping_pages(mapping, start_index,
> >+						end_index, force);
> >  		break;
> >  	default:
> >  		ret = -EINVAL;
> 
> 
> -- 
> All rights reversed
