Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2LKCZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:25:37 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:48875 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2LKCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:25:37 -0500
Message-ID: <50C6997C.1080702@huawei.com>
Date: Tue, 11 Dec 2012 10:25:00 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        <Vyacheslav.Dubeyko@huawei.com>, Borislav Petkov <bp@alien8.de>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wency@cn.fujitsu.com>, <fengguang.wu@intel.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org>
In-Reply-To: <20121210153805.GS16230@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/10 23:38, Andi Kleen wrote:

>> It is another topic, I mean since the page is poisoned, so why not isolate it
>> from page buddy alocator in soft_offline_page() rather than in check_new_page().
>> I find soft_offline_page() only migrate the page and mark HWPoison, the poisoned
>> page is still managed by page buddy alocator.
> 
> Doing it in check_new_page is the only way if the page is currently
> allocated by someone. Since that's not uncommon it's simplest to always
> do it this way.
> 
> -Andi
> 

Hi Andi,

The poisoned page is isolated in check_new_page, however the whole buddy block will
be dropped, it seems to be a waste of memory.

Can we separate the poisoned page from the buddy block, then *only* drop the poisoned
page?

Thanks
Xishi Qiu


