Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2LKCpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:45:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:54852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2LKCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:45:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,255,1355126400"; 
   d="scan'208";a="260281003"
Date: Tue, 11 Dec 2012 10:45:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andi Kleen <andi@firstfloor.org>, Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211024522.GA10505@localhost>
References: <50C1AD6D.7010709@huawei.com>
 <20121207141102.4fda582d.akpm@linux-foundation.org>
 <20121210083342.GA31670@hacker.(null)>
 <50C5A62A.6030401@huawei.com>
 <1355136423.1700.2.camel@kernel.cn.ibm.com>
 <50C5C4A2.2070002@huawei.com>
 <20121210153805.GS16230@one.firstfloor.org>
 <50C6997C.1080702@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C6997C.1080702@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:25:00AM +0800, Xishi Qiu wrote:
> On 2012/12/10 23:38, Andi Kleen wrote:
> 
> >> It is another topic, I mean since the page is poisoned, so why not isolate it
> >> from page buddy alocator in soft_offline_page() rather than in check_new_page().
> >> I find soft_offline_page() only migrate the page and mark HWPoison, the poisoned
> >> page is still managed by page buddy alocator.
> > 
> > Doing it in check_new_page is the only way if the page is currently
> > allocated by someone. Since that's not uncommon it's simplest to always
> > do it this way.
> > 
> > -Andi
> > 
> 
> Hi Andi,
> 
> The poisoned page is isolated in check_new_page, however the whole buddy block will
> be dropped, it seems to be a waste of memory.
> 
> Can we separate the poisoned page from the buddy block, then *only* drop the poisoned
> page?

That sounds like overkill. There are not so many free pages in a
typical server system.

Thanks,
Fengguang
