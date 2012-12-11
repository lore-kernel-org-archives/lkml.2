Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2LKDTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:19:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43662 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKDTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:19:11 -0500
Date: Tue, 11 Dec 2012 04:19:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Xishi Qiu <qiuxishi@huawei.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211031907.GZ16230@one.firstfloor.org>
References: <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org> <1355190540.1933.4.camel@kernel.cn.ibm.com> <20121211020313.GV16230@one.firstfloor.org> <1355192071.1933.7.camel@kernel.cn.ibm.com> <20121211030125.GY16230@one.firstfloor.org> <1355195591.1933.18.camel@kernel.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355195591.1933.18.camel@kernel.cn.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 09:13:11PM -0600, Simon Jeons wrote:
> On Tue, 2012-12-11 at 04:01 +0100, Andi Kleen wrote:
> > > Oh, it will be putback to lru list during migration. So does your "some
> > > time" mean before call check_new_page?
> > 
> > Yes until the next check_new_page() whenever that is. If the migration
> > works it will be earlier, otherwise later.
> 
> But I can't figure out any page reclaim path check if the page is set
> PG_hwpoison, can poisoned pages be rclaimed?

The only way to reclaim a page is to free and reallocate it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
