Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0EVIfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:35:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53070 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab0EVIfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:35:51 -0400
Message-ID: <4BF79761.5000402@cs.helsinki.fi>
Date: Sat, 22 May 2010 11:35:45 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Alexander Duyck <alexander.h.duyck@intel.com>
CC: cl@linux.com, linux-mm@kvack.org, alex.shi@intel.com,
       yanmin_zhang@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH v2] slub: move kmem_cache_node into it's own cacheline
References: <20100521214135.23902.55360.stgit@gitlad.jf.intel.com>
In-Reply-To: <20100521214135.23902.55360.stgit@gitlad.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Duyck wrote:
> This patch is meant to improve the performance of SLUB by moving the local
> kmem_cache_node lock into it's own cacheline separate from kmem_cache.
> This is accomplished by simply removing the local_node when NUMA is enabled.
> 
> On my system with 2 nodes I saw around a 5% performance increase w/
> hackbench times dropping from 6.2 seconds to 5.9 seconds on average.  I
> suspect the performance gain would increase as the number of nodes
> increases, but I do not have the data to currently back that up.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>

Thanks for the fix, Alexander!

Yanmin and Alex, can I have your Tested-by or Acked-by please so we can 
close "[Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e" 
after this patch is merged?

			Pekka
