Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HQNYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:24:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59688 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2HQNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:24:15 -0400
Date: Fri, 17 Aug 2012 06:24:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: qiuxishi <qiuxishi@gmail.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, tony.luck@intel.com,
        yinghai@kernel.org, jiang.liu@huawei.com, qiuxishi@huawei.com,
        bessel.wang@huawei.com, wujianguo@huawei.com,
        paul.gortmaker@windriver.com, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
        minchan@kernel.org, chenkeping@huawei.com, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, liuj97@gmail.com
Subject: Re: [PATCH] memory hotplug: avoid double registration on ia64
 platform
Message-ID: <20120817132410.GB28980@kroah.com>
References: <502DF84F.8040708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502DF84F.8040708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 03:52:47PM +0800, qiuxishi wrote:
> From: Xishi Qiu <qiuxishi@huawei.com>
> 
> Hi all,
> There may be have a bug when register section info. For example, on
> an Itanium platform, the pfn range of node0 includes the other nodes.
> So when hot remove memory, we can't free the memmap's page because
> page_count() is 2 after put_page_bootmem().
> 
> sparse_remove_one_section()->free_section_usemap()->free_map_bootmem()
> ->put_page_bootmem()
> 
> pgdat0: start_pfn=0x100,    spanned_pfn=0x20fb00, present_pfn=0x7f8a3, => 0x100-0x20fc00
> pgdat1: start_pfn=0x80000,  spanned_pfn=0x80000,  present_pfn=0x80000, => 0x80000-0x100000
> pgdat2: start_pfn=0x100000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x100000-0x180000
> pgdat3: start_pfn=0x180000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x180000-0x200000
> 
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  mm/memory_hotplug.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
