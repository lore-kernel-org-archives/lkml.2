Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1A2Irr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:47:47 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1A2Irq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:47:46 -0500
Subject: Re: [PATCH 1/7] [v2] zram/vmalloc: Correct tunings to enable use
 with 64K pages
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128145726.GB2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128145726.GB2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:47:44 +0200
Message-ID: <1296290864.30654.5.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 08:57 -0600, Robert Jennings wrote:
> xvmalloc will not currently function with 64K pages.  Newly allocated
> pages will be inserted at an offset beyond the end of the first-level
> index.  This tuning is needed to properly size the allocator for 64K
> pages.
> 
> The default 3 byte shift results in a second level list size which can not
> be indexed using the 64 bits of the flbitmap in the xv_pool structure.
> The shift must increase to 4 bytes between second level list entries to
> fit the size of the first level bitmap.
> 
> Here are a few statistics for structure sizes on 32- and 64-bit CPUs
> with 4KB and 64KB page sizes.
> 
> bits_per_long              32        64        64
> page_size               4,096     4,096    65,535
> xv_align                    4         8         8
> fl_delta                    3         3         4
> num_free_lists            508       508     4,094
> xv_pool size            4,144b    8,216b   66,040b
> per object overhead        32        64        64
> zram struct 0.5GB disk    512KB    1024KB      64KB
> 
> This patch maintains the current tunings for 4K pages, adds an optimal
> sizing for 64K pages and adds a safe tuning for any other page sizes.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

