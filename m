Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031298Ab2CUOtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:49:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030197Ab2CUOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:49:49 -0400
Subject: Re: Patch workqueue: create new slab cache instead of hacking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1203210910450.20482@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
	 <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com>
	 <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com>
	 <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
	 <alpine.DEB.2.00.1203210910450.20482@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 07:49:41 -0700
Message-ID: <1332341381.7893.17.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 09:12 -0500, Christoph Lameter wrote:
> How about this instead?
> 
> Subject: workqueues: Use new kmem cache to get aligned memory for workqueues
> 
> The workqueue logic currently improvises by doing a kmalloc allocation and
> then aligning the object. Create a slab cache for that purpose with the
> proper alignment instead.
> 
> Cleans up the code and makes things much simpler. No need anymore to carry
> an additional pointer to the beginning of the kmalloc object.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Creating a dedicated cache for few objects ? Thats a lot of overhead, at
least for SLAB (no merges of caches)

By the way network stack also wants to align struct net_device (in
function alloc_netdev_mqs(), and uses a custom code.

In this case, as the size of net_device is not constant, we use standard
kzalloc().

No idea why NETDEV_ALIGN is 32 ... Oh well, some old constant instead of
L1_CACHE_BYTES ...





