Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab1DLXzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:55:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1DLXzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tm6KdU+c9wh9FCxmefW5kNv+Q1PgzAlM4MtQbeTfNKIWxiPB1vHv5eEBkEZTSbKwkp
         bCyzTJ+mtg3C3efPu5aw==
Date: Tue, 12 Apr 2011 16:55:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: per-node vmstat show proper vmstats
In-Reply-To: <20110411201015.F5BC.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104121654340.10966@chino.kir.corp.google.com>
References: <20110411201015.F5BC.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, KOSAKI Motohiro wrote:

> commit 2ac390370a (writeback: add /sys/devices/system/node/<node>/vmstat)
> added vmstat entry. But strangely it only show nr_written and nr_dirtied.
> 
>         # cat /sys/devices/system/node/node20/vmstat
>         nr_written 0
>         nr_dirtied 0
> 
> Of cource, It's no adequate. With this patch, the vmstat show
> all vm stastics as /proc/vmstat.
> 
>         # cat /sys/devices/system/node/node0/vmstat
> 	nr_free_pages 899224
> 	nr_inactive_anon 201
> 	nr_active_anon 17380
> 	nr_inactive_file 31572
> 	nr_active_file 28277
> 	nr_unevictable 0
> 	nr_mlock 0
> 	nr_anon_pages 17321
> 	nr_mapped 8640
> 	nr_file_pages 60107
> 	nr_dirty 33
> 	nr_writeback 0
> 	nr_slab_reclaimable 6850
> 	nr_slab_unreclaimable 7604
> 	nr_page_table_pages 3105
> 	nr_kernel_stack 175
> 	nr_unstable 0
> 	nr_bounce 0
> 	nr_vmscan_write 0
> 	nr_writeback_temp 0
> 	nr_isolated_anon 0
> 	nr_isolated_file 0
> 	nr_shmem 260
> 	nr_dirtied 1050
> 	nr_written 938
> 	numa_hit 962872
> 	numa_miss 0
> 	numa_foreign 0
> 	numa_interleave 8617
> 	numa_local 962872
> 	numa_other 0
> 	nr_anon_transparent_hugepages 0
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Michael Rubin <mrubin@google.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>

This is very useful for cpuset users.

Acked-by: David Rientjes <rientjes@google.com>
