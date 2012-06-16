Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2FPHaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 03:30:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51131 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2FPHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 03:30:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FDC358F.6020905@jp.fujitsu.com>
Date: Sat, 16 Jun 2012 16:28:15 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB
 v2
References: <1339542816-21663-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1339542816-21663-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 8:13), Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
> 
> There was some desire in large applications using MAP_HUGETLB/SHM_HUGETLB
> to use 1GB huge pages on some mappings, and stay with 2MB on others. This
> is useful together with NUMA policy: use 2MB interleaving on some mappings,
> but 1GB on local mappings.
> 
> This patch extends the IPC/SHM syscall interfaces slightly to allow specifying
> the page size.
> 
> It borrows some upper bits in the existing flag arguments and allows encoding
> the log of the desired page size in addition to the *_HUGETLB flag.
> When 0 is specified the default size is used, this makes the change fully
> compatible.
> 
> Extending the internal hugetlb code to handle this is straight forward. Instead
> of a single mount it just keeps an array of them and selects the right
> mount based on the specified page size.
> 
> I also exported the new flags to the user headers
> (they were previously under __KERNEL__). Right now only symbols
> for x86 and some other architecture for 1GB and 2MB are defined.
> The interface should already work for all other architectures
> though.
> 
> v2: Port to new tree. Fix unmount.
> Signed-off-by: Andi Kleen<ak@linux.intel.com>

I like this.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, do you have any plan to implement 1GB page allocator ?
I wonder recent contiguous-memory-allocator works can be used for...




