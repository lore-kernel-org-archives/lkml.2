Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2LNPiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:38:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab2LNPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:38:16 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Borislav Petkov <bp@alien8.de>,
        Simon Jeons <simon.jeons@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: clean up soft_offline_page()
Date: Fri, 14 Dec 2012 10:37:36 -0500
Message-Id: <1355499456-3311-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <50CA97D0.4020401@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xishi,

On Fri, Dec 14, 2012 at 11:06:56AM +0800, Xishi Qiu wrote:
> On 2012/12/14 7:01, Naoya Horiguchi wrote:
...
> > +	ret = get_any_page(page, pfn, flags);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret) { /* for in-use pages */
> > +		if (PageHuge(page))
> > +			soft_offline_huge_page(page, flags);
> 
> ret = soft_offline_huge_page(page, flags);
> 
> > +		else
> > +			__soft_offline_page(page, flags);
> 
> ret = __soft_offline_page(page, flags); right?

Ah, you're right, Thanks!

Naoya
