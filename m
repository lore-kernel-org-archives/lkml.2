Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2LJPiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:38:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42990 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJPiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:38:12 -0500
Date: Mon, 10 Dec 2012 16:38:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        wency@cn.fujitsu.com
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121210153805.GS16230@one.firstfloor.org>
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5C4A2.2070002@huawei.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is another topic, I mean since the page is poisoned, so why not isolate it
> from page buddy alocator in soft_offline_page() rather than in check_new_page().
> I find soft_offline_page() only migrate the page and mark HWPoison, the poisoned
> page is still managed by page buddy alocator.

Doing it in check_new_page is the only way if the page is currently
allocated by someone. Since that's not uncommon it's simplest to always
do it this way.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
