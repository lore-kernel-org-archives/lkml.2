Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0DNSOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:14:24 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48561 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab0DNSOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:14:23 -0400
Date: Wed, 14 Apr 2010 11:11:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: update documentation v7
Message-Id: <20100414111146.c2907cd7.randy.dunlap@oracle.com>
In-Reply-To: <20100414102221.2c540a0d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100408145800.ca90ad81.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409134553.58096f80.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409100430.7409c7c4.randy.dunlap@oracle.com>
	<20100413134553.7e2c4d3d.kamezawa.hiroyu@jp.fujitsu.com>
	<20100413060405.GF3994@balbir.in.ibm.com>
	<20100413152048.55408738.kamezawa.hiroyu@jp.fujitsu.com>
	<20100413064855.GH3994@balbir.in.ibm.com>
	<20100413155841.ca6bc425.kamezawa.hiroyu@jp.fujitsu.com>
	<4BC493B4.2040709@oracle.com>
	<20100414102221.2c540a0d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BC605CF.0120:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  Documentation/cgroups/memory.txt |  289 ++++++++++++++++++++++++++-------------
>  1 file changed, 197 insertions(+), 92 deletions(-)
> 
> Index: mmotm-temp/Documentation/cgroups/memory.txt
> ===================================================================
> --- mmotm-temp.orig/Documentation/cgroups/memory.txt
> +++ mmotm-temp/Documentation/cgroups/memory.txt
> @@ -1,18 +1,15 @@
>  Memory Resource Controller
>  
>  NOTE: The Memory Resource Controller has been generically been referred
> -to as the memory controller in this document. Do not confuse memory controller
> -used here with the memory controller that is used in hardware.
> +      to as the memory controller in this document. Do not confuse memory
> +      controller used here with the memory controller that is used in hardware.
>  
> -Salient features
> -
> -a. Enable control of Anonymous, Page Cache (mapped and unmapped) and
> -   Swap Cache memory pages.
> -b. The infrastructure allows easy addition of other types of memory to control
> -c. Provides *zero overhead* for non memory controller users
> -d. Provides a double LRU: global memory pressure causes reclaim from the
> -   global LRU; a cgroup on hitting a limit, reclaims from the per
> -   cgroup LRU
> +(For editors)
> +In this document:
> +      When we mention a cgroup (cgroupfs's directory) with memory controller,
> +      we call it "memory cgroup". When you see git-log and source code, you'll
> +      see patch's title and function names tend to use "memcg".
> +      In this document, we avoid to use it.

	                   we avoid using it.

>  
>  Benefits and Purpose of the memory controller

> @@ -501,27 +605,28 @@ It's applicable for root and non-root cg
>  
>  memory.oom_control file is for OOM notification and other controls.
>  
> -Memory controler implements oom notifier using cgroup notification
> -API (See cgroups.txt). It allows to register multiple oom notification
> -delivery and gets notification when oom happens.
> +Memory cgroup implements OOM notifier using cgroup notification
> +API (See cgroups.txt). It allows to register multiple OOM notification
> +delivery and gets notification when OOM happens.
>  
>  To register a notifier, application need:
>   - create an eventfd using eventfd(2)
>   - open memory.oom_control file
> - - write string like "<event_fd> <memory.oom_control>" to cgroup.event_control
> + - write string like "<event_fd> <fd of memory.oom_control>" to
> +   cgroup.event_control
>  
> -Application will be notifier through eventfd when oom happens.
> +Application will be notified through eventfd when OOM happens.
>  OOM notification doesn't work for root cgroup.
>  
> -You can disable oom-killer by writing "1" to memory.oom_control file.
> +You can disable OOM-killer by writing "1" to memory.oom_control file.
>  As.

                                             to memory.oom_control file, as:

>  	#echo 1 > memory.oom_control


BTW:  it would be a lot easier [for reviewing] if you could freeze (or merge) this version
and then apply fixes on top of it with a different (and shorter) patch.

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
