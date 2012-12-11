Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2LKD01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:26:27 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16917 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2LKD00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:26:26 -0500
Message-ID: <50C6A7BC.8010200@huawei.com>
Date: Tue, 11 Dec 2012 11:25:48 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        <Vyacheslav.Dubeyko@huawei.com>, Borislav Petkov <bp@alien8.de>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <wency@cn.fujitsu.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org> <50C6997C.1080702@huawei.com> <20121211024522.GA10505@localhost> <20121211025857.GX16230@one.firstfloor.org>
In-Reply-To: <20121211025857.GX16230@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/11 10:58, Andi Kleen wrote:

>> That sounds like overkill. There are not so many free pages in a
>> typical server system.
> 
> As Fengguang said -- memory error handling is tricky. Lots of things
> could be done in theory, but they all have a cost in testing and 
> maintenance. 
> 
> In general they are only worth doing if the situation is common and
> represents a significant percentage of the total pages of a relevant server
> workload.
> 
> -Andi
> 

Hi Andi and Fengguang,

"There are not so many free pages in a typical server system", sorry I don't
quite understand it.

buffered_rmqueue()
	prep_new_page()
		check_new_page()
			bad_page()

If we alloc 2^10 pages and one of them is a poisoned page, then the whole 4M
memory will be dropped.

Thanks,
Xishi Qiu

