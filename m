Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2LKCDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:03:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2LKCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:03:19 -0500
Date: Tue, 11 Dec 2012 03:03:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Xishi Qiu <qiuxishi@huawei.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211020313.GV16230@one.firstfloor.org>
References: <50C1AD6D.7010709@huawei.com> <20121207141102.4fda582d.akpm@linux-foundation.org> <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com> <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com> <20121210153805.GS16230@one.firstfloor.org> <1355190540.1933.4.camel@kernel.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355190540.1933.4.camel@kernel.cn.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIUC, soft offlining will isolate and migrate hwpoisoned page, and this
> page will not be accessed by memory management subsystem until unpoison,
> correct?

No, soft offlining can still allow accesses for some time. It'll never kill
anything.

Hard tries much harder and will kill.

In some cases (unshrinkable kernel allocation) they end up doing the same
because there isn't any other alternative though. However these are
expected to only apply to a small percentage of pages in a typical
system.

-Andi
