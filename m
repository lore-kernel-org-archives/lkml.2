Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1KZAF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 19:05:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1KZAFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 19:05:25 -0500
Date: Sat, 26 Nov 2011 01:05:21 +0100
From: Jan Kara <jack@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Love <rlove@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
Message-ID: <20111126000521.GA26326@quack.suse.cz>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
 <4ECB6D60.1010702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB6D60.1010702@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 04:37:36, Rik van Riel wrote:
> On 11/21/2011 10:33 PM, John Stultz wrote:
> The idea is quite simple:
> 
> 1) Every program that we are interested in already has
>    some kind of main loop where it polls on file descriptors.
>    It is easy for such programs to add an additional file,
>    which would be a device or sysfs file that wakes up the
>    program from its poll/select loop when memory is getting
>    full to the point that userspace needs to shrink its
>    caches.
> 
>    The kernel can be smart here and wake up just one process
>    at a time, targeting specific NUMA nodes or cgroups. Such
>    kernel smarts do not require additional userspace changes.
> 
> 2) When userspace gets such a "please shrink your caches"
>    event, it can do various things.  A program like firefox
>    could throw away several cached objects, eg. uncompressed
>    images or entire pre-rendered tabs, while a JVM can shrink
>    its heap size and a database could shrink its internal
>    cache.
  Hmm, I wonder here: How much should a program free? A single object? Or
one meg of memory? I find this decision rather problematic. How much should
be reclaimed depends on the number of applications listening, how aggressive
they are, and current memory pressure => it's basically unpredictable from
userspace so you are almost guaranteed to either reclaim too much or too
few. Advantage of the VOLATILE approach is that kernel (which is the only
place where there is all necessary information) controls how much memory
is evicted... Just one argument for VOLATILE approach I didn't see
mentioned in the discussion yet.

								Honza
