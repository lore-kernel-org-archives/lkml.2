Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0IUHYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:24:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37439 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0IUHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:23:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kenneth <liguozhu@huawei.com>
Subject: Re: Problem with debugfs
Cc: kosaki.motohiro@jp.fujitsu.com, greg@kroah.com,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20100921061310.GA11526@localhost>
References: <20100921022112.GA10336@localhost> <20100921061310.GA11526@localhost>
Message-Id: <20100921162316.3C03.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 21 Sep 2010 16:23:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello, Mr. Greg,
> 
> I'm sorry I had not checked the git before sending my last mail.
> 
> For the problem I mention, consider this scenarios:
> 
> 1. mm/hwpoinson-inject.c create a debugfs file with
>    debugfs_create_u64("corrupt-filter-flags-mask", ...,
>    &hwpoison_filter_flags_mask)
> 2. hwpoison_filter_flags_mask is supposed to be protected by filp->priv->mutex
>    of this file when it is accessed from user space.
> 3. but when it is accessed from mm/memory-failure.c:hwpoison_filter_flags,
>    there is no way for the function to protect the operation (so it simply
>    ignore it). This may create a competition problem.
> 
> It should be a problem.
> 
> I'm sorry from my poor English skill.

I think your english is very clear :)
Let's cc hwpoison folks.


 - kosaki 


> 
> Best Regards
> Kenneth Lee
> 
> On Tue, Sep 21, 2010 at 10:21:12AM +0800, kenny wrote:
> > Hi, there,
> > 
> > I do not know who is the maintainer for debugfs now. But I think there is
> > problem with its API: It uses filp->priv->mutex to protect the read/write (to
> > the file) for the value of its attribute, but the mutex is not exported to the
> > API user.  Therefore, there is no way to protect its value when you directly
> > use the value in your module.
> > 
> > Is my understanding correct?
> > 
> > Thanks
> > 
> > 
> > Best Regards
> > Kenneth Lee
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



