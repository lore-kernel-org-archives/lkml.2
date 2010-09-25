Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0IYBZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 21:25:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48943 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0IYBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 21:25:08 -0400
Date: Sat, 25 Sep 2010 09:18:00 +0800
From: Kenneth <liguozhu@huawei.com>
Subject: Re: Problem with debugfs
In-reply-to: <20100921061310.GA11526@localhost>
To: linux-kernel@vger.kernel.org
Message-id: <20100925011800.GA6073@localhost>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
References: <20100921022112.GA10336@localhost>
 <20100921061310.GA11526@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

Yes, the problem is from code review, rather than in practice. I just wrote a
doc to introduce debugfs, and then I could not find a way to protect the
variable:)

I think add a comment to the header file will be good enough for this.

-- Kenneth


On Tue, Sep 21, 2010 at 02:13:10PM +0800, Kenneth wrote:
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

