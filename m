Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2LKBtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:49:06 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:59444 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKBtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:49:04 -0500
Message-ID: <1355190540.1933.4.camel@kernel.cn.ibm.com>
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
From: Simon Jeons <simon.jeons@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Vyacheslav.Dubeyko@huawei.com, Borislav Petkov <bp@alien8.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, wency@cn.fujitsu.com
Date: Mon, 10 Dec 2012 19:49:00 -0600
In-Reply-To: <20121210153805.GS16230@one.firstfloor.org>
References: <50C1AD6D.7010709@huawei.com>
	 <20121207141102.4fda582d.akpm@linux-foundation.org>
	 <20121210083342.GA31670@hacker.(null)> <50C5A62A.6030401@huawei.com>
	 <1355136423.1700.2.camel@kernel.cn.ibm.com> <50C5C4A2.2070002@huawei.com>
	 <20121210153805.GS16230@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 16:38 +0100, Andi Kleen wrote:
> > It is another topic, I mean since the page is poisoned, so why not isolate it
> > from page buddy alocator in soft_offline_page() rather than in check_new_page().
> > I find soft_offline_page() only migrate the page and mark HWPoison, the poisoned
> > page is still managed by page buddy alocator.
> 
> Doing it in check_new_page is the only way if the page is currently
> allocated by someone. Since that's not uncommon it's simplest to always
> do it this way.

Hi Andi,

IIUC, soft offlining will isolate and migrate hwpoisoned page, and this
page will not be accessed by memory management subsystem until unpoison,
correct?

                             -Simon

> 
> -Andi
> 


