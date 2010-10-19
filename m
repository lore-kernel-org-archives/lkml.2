Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0JSTLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:11:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0JSTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=eTc3ea69+CKQL//AZ+ZOA/hlgtDEQqi8ocSuQfJQZZ4hWFgMp3gvilfWd6GZ5FnGtw
         tB90lYyKl6QZK43MZ//A==
Date: Tue, 19 Oct 2010 12:11:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [resend][PATCH 2/2] mm, mem-hotplug: update pcp->stat_threshold
 when memory hotplug occur
In-Reply-To: <20101019140955.A1EE.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010191208130.15499@chino.kir.corp.google.com>
References: <20101019140831.A1EB.A69D9226@jp.fujitsu.com> <20101019140955.A1EE.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, KOSAKI Motohiro wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 14ee899..222d8cc 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -51,6 +51,7 @@
>  #include <linux/kmemleak.h>
>  #include <linux/memory.h>
>  #include <linux/compaction.h>
> +#include <linux/vmstat.h>
>  #include <trace/events/kmem.h>
>  #include <linux/ftrace_event.h>
>  
> @@ -5013,6 +5014,8 @@ int __meminit init_per_zone_wmark_min(void)
>  		min_free_kbytes = 128;
>  	if (min_free_kbytes > 65536)
>  		min_free_kbytes = 65536;
> +
> +	refresh_zone_stat_thresholds();
>  	setup_per_zone_wmarks();
>  	setup_per_zone_lowmem_reserve();
>  	setup_per_zone_inactive_ratio();

setup_per_zone_wmarks() could change the min and low watermarks for a zone 
when refresh_zone_stat_thresholds() would have used the old value.
