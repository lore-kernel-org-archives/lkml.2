Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2BCXMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 18:12:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab2BCXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 18:12:31 -0500
Date: Fri, 3 Feb 2012 15:12:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: huge debug_objects_cache. swapping but 25% mem free
Message-Id: <20120203151218.59ceb1c1.akpm@linux-foundation.org>
In-Reply-To: <20120201182932.GA15518@sig21.net>
References: <20120130154048.GA421@sig21.net>
	<20120201182932.GA15518@sig21.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 19:29:32 +0100
Johannes Stezenbach <js@sig21.net> wrote:

> On Mon, Jan 30, 2012 at 04:40:48PM +0100, Johannes Stezenbach wrote:
> > 
> > According to slabtop debug_objects_cache eats half the
> > memory, is this expected?  The Kconfig help text does not
> > suggest it.
> 
> FWIW, today after running full backup using rsync:
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 4025450 4025447  99%    0.36K 183977       22   1471816K debug_objects_cache
> 170266  87241  51%    1.74K   9645       18    308640K ext3_inode_cache
>  54855  40215  73%    0.58K   2034       27     32544K dentry
>  38124  12474  32%    0.42K   2119       18     16952K buffer_head
>  17794  17464  98%    0.51K    574       31      9184K sysfs_dir_cache
>  11434   8494  74%    0.87K    713       18     11408K radix_tree_node
>  11400   5570  48%    0.38K    570       20      4560K kmalloc-64
> 
> /sys/kernel/debug/debug_objects/stats:
> max_chain     :870
> warnings      :0
> fixups        :0
> pool_free     :258
> pool_min_free :252
> pool_used     :4025193
> pool_max_used :4025195
> 
> 
> then after "echo 3 >/proc/sys/vm/drop_caches":
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 4030488 4030485  99%    0.36K 184206       22   1473648K debug_objects_cache
>  17955   9071  50%    0.58K    665       27     10640K dentry
>  17763  17455  98%    0.51K    573       31      9168K sysfs_dir_cache
>   9408   9156  97%    0.33K    392       24      3136K kmalloc-8
> 
> 
> I'm still not sure if this is normal behaviour of DEBUG_OBJECTS or a bug?

Bug.  It appears that you hadn't been using CONFIG_DEBUG_OBJECTS before
3.2 so we don't know if it is a regression.

