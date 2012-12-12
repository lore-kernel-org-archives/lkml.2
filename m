Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2LLEXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:23:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2LLEXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:23:23 -0500
Date: Wed, 12 Dec 2012 05:23:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: WuJianguo <wujianguo@huawei.com>, Liujiang <jiang.liu@huawei.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 2/3] MCE: fix an error of mce_bad_pages statistics
Message-ID: <20121212042316.GC16230@one.firstfloor.org>
References: <50C7FB82.7050802@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C7FB82.7050802@huawei.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	if (PageHWPoison(hpage)) {
>  		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
> -		return -EBUSY;
> +		ret = -EBUSY;
> +		goto out;


Doesn't look like a code improvement to me. Single return is easier and
simpler.

-Andi

> +out:
>  	return ret;
>  }
> -- 
> 1.7.1
> 
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
