Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561Ab0COPry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:47:54 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:39424 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936228Ab0COPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:47:52 -0400
Date: Mon, 15 Mar 2010 08:46:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: balbir@linux.vnet.ibm.com
Cc: KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-Id: <20100315084631.a350f066.randy.dunlap@oracle.com>
In-Reply-To: <20100315072214.GA18054@balbir.in.ibm.com>
References: <20100315072214.GA18054@balbir.in.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B9E5680.012E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 12:52:15 +0530 Balbir Singh wrote:

> Selectively control Unmapped Page Cache (nospam version)
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> This patch implements unmapped page cache control via preferred
> page cache reclaim. The current patch hooks into kswapd and reclaims
> page cache if the user has requested for unmapped page control.
> This is useful in the following scenario
> 
> - In a virtualized environment with cache!=none, we see
>   double caching - (one in the host and one in the guest). As
>   we try to scale guests, cache usage across the system grows.
>   The goal of this patch is to reclaim page cache when Linux is running
>   as a guest and get the host to hold the page cache and manage it.
>   There might be temporary duplication, but in the long run, memory
>   in the guests would be used for mapped pages.
> - The option is controlled via a boot option and the administrator
>   can selectively turn it on, on a need to use basis.
> 
> A lot of the code is borrowed from zone_reclaim_mode logic for
> __zone_reclaim(). One might argue that the with ballooning and
> KSM this feature is not very useful, but even with ballooning,
> we need extra logic to balloon multiple VM machines and it is hard
> to figure out the correct amount of memory to balloon. With these
> patches applied, each guest has a sufficient amount of free memory
> available, that can be easily seen and reclaimed by the balloon driver.
> The additional memory in the guest can be reused for additional
> applications or used to start additional guests/balance memory in
> the host.
> 
> KSM currently does not de-duplicate host and guest page cache. The goal
> of this patch is to help automatically balance unmapped page cache when
> instructed to do so.
> 
> There are some magic numbers in use in the code, UNMAPPED_PAGE_RATIO
> and the number of pages to reclaim when unmapped_page_control argument
> is supplied. These numbers were chosen to avoid aggressiveness in
> reaping page cache ever so frequently, at the same time providing control.
> 
> The sysctl for min_unmapped_ratio provides further control from
> within the guest on the amount of unmapped pages to reclaim.
> 
> The patch is applied against mmotm feb-11-2010.

Hi,
If you go ahead with this, please add the boot parameter & its description
to Documentation/kernel-parameters.txt.


> TODOS
> -----
> 1. Balance slab cache as well
> 2. Invoke the balance routines from the balloon driver

---
~Randy
