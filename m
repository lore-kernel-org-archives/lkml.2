Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2LKNpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:45:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44108 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2LKNpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:45:14 -0500
Date: Tue, 11 Dec 2012 14:45:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/2] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121211134509.GB16230@one.firstfloor.org>
References: <50C72493.3080009@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C72493.3080009@huawei.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:18:27PM +0800, Xishi Qiu wrote:
> 1) move poisoned page check at the beginning of the function.
> 2) add page_lock to avoid unpoison clear the flag.

That doesn't make sense, obviously you would need to recheck
inside the lock again to really protect against unpoison.

But unpoison is only for debugging anyways, so it doesn't matter
if the count is 100% correct.

-Andi
