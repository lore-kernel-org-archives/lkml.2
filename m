Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0LWA3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:29:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857Ab0LWA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:29:45 -0500
Date: Wed, 22 Dec 2010 16:27:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: shaohui.zheng@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, rientjes@google.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/7, v9] NUMA Hotplug Emulator: Add numa=possible option
Message-Id: <20101222162717.289cfe01.akpm@linux-foundation.org>
In-Reply-To: <20101210073242.357094158@intel.com>
References: <20101210073119.156388875@intel.com>
	<20101210073242.357094158@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 15:31:21 +0800
shaohui.zheng@intel.com wrote:

> @@ -646,6 +647,15 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
>  		numa_set_node(i, 0);
>  	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
>  	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
> +out: __maybe_unused

hm, I didn't know you could do that with labels.

Does it work?

> +	for (i = 0; i < numa_possible_nodes; i++) {
> +		int nid;
> +
> +		nid = first_unset_node(node_possible_map);
> +		if (nid == MAX_NUMNODES)
> +			break;
> +		node_set(nid, node_possible_map);
> +	}
>  }
>  
>  unsigned long __init numa_free_all_bootmem(void)
