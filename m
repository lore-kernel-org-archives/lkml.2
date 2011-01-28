Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1A1O4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:56:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45148 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1A1O4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:56:06 -0500
Date: Fri, 28 Jan 2011 08:56:03 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7][v2] zram/xvmalloc: 64K page fixes and optimizations
Message-ID: <20110128145602.GA2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on feedback this is version 2 of my patches to fix zram and the
xvmalloc allocator for 64K page size kernels along with a few small
zram optimizations.

I have dropped the patch to mark the device as non-rotational media as
this was duplicated elsewhere.  I also dropped the patch regarding caching
the indices for page size allocations because gcc is quite smart.

There are two new patches at the end of this patch set.  The first
changes zram to return zero'd pages for reads of pages which have not
been written to, this eliminates passing uninitialized pages back
to user-space.  The second new patch cleans up freelist pointer
management and combines the two delete node functions into one common
function.

The xvmalloc allocator is non-functional when running with a 64K page
size.  The first two patches fix 64K page related issues.
[1/7] [v2] zram/vmalloc: Correct tunings to enable use with 64K pages
[2/7] [v2] zram: Prevent overflow in logical block size

The next 3 patches provide some small optimizations for zram and
xvmalloc.
[3/7] [v2] zram/xvmalloc: free bit block insertion optimization
[4/7] [v2] zram/xvmalloc: create CONFIG_ZRAM_DEBUG for debug code
[5/7] [v2] zram/xvmalloc: Close 32byte hole on 64bit CPUs

These last 2 patches are new, see the description above.
[6/7] zram: Return zero'd pages on new reads
[7/7] zram/xvmalloc: combine duplicate block delete code

Thanks for the helpful reviews.

Regards,
Robert Jennings
