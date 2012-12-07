Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2LGWsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:48:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59355 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2LGWsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:48:10 -0500
Date: Fri, 7 Dec 2012 23:41:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
        Liujiang <jiang.liu@huawei.com>, Vyacheslav.Dubeyko@huawei.com,
        andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121207224110.GA32115@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xishi Qiu <qiuxishi@huawei.com>, WuJianguo <wujianguo@huawei.com>,
	Liujiang <jiang.liu@huawei.com>, Vyacheslav.Dubeyko@huawei.com,
	andi@firstfloor.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <50C1AD6D.7010709@huawei.com>
 <20121207141102.4fda582d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121207141102.4fda582d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:11:02PM -0800, Andrew Morton wrote:
> A few things:
> 
> - soft_offline_page() already checks for this case:
> 
> 	if (PageHWPoison(page)) {
> 		unlock_page(page);
> 		put_page(page);
> 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
> 		return -EBUSY;
> 	}

Oh, so we do this check after all. But later in the function. Why? Why
not at the beginning so that when a page is marked poisoned already we
can exit early?

Strange.

-- 
Regards/Gruss,
    Boris.
