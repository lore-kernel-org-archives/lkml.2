Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1CKDUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:20:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44813 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CKDUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:20:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Mar 2011 12:13:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Justin TerAvest <teravest@google.com>, m-ikeda <m-ikeda@ds.jp.nec.com>,
        jaxboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ryov <ryov@valinux.co.jp>,
        taka <taka@valinux.co.jp>, "righi.andrea" <righi.andrea@gmail.com>,
        guijianfeng <guijianfeng@cn.fujitsu.com>,
        balbir <balbir@linux.vnet.ibm.com>, ctalbott <ctalbott@google.com>,
        nauman <nauman@google.com>, mrubin <mrubin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Storing cgroup id in page->private (Was: Re: [RFC] [PATCH
 0/6] Provide cgroup isolation for buffered writes.)
Message-Id: <20110311121343.23c61461.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110311031503.GC11710@redhat.com>
References: <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
	<20110310191115.GG29464@redhat.com>
	<20110310194106.GH29464@redhat.com>
	<1299791640-sup-1874@think>
	<3EC7D30A-B8F7-416B-8B1D-A19350C57D82@dilger.ca>
	<20110310213832.GK29464@redhat.com>
	<1299793340-sup-9066@think>
	<20110311014618.GC15097@dastard>
	<20110311021531.GA11710@redhat.com>
	<20110311115235.3663792c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110311031503.GC11710@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 22:15:04 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Mar 11, 2011 at 11:52:35AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 10 Mar 2011 21:15:31 -0500
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> >  
> > > > IMO, if you really need some per-page information, then just put it
> > > > in the struct page - you can't hide the memory overhead just by
> > > > having the filesystem to store it for you. That just adds
> > > > unnecessary complexity...
> > > 
> > > Ok. I guess adding anything to struct page is going to be hard and 
> > > we might have to fall back to looking into using page_cgroup for
> > > tracking page state. I was trying to explore the ways so that we don't
> > > have to instantiate whole page_cgroup structure just for trying
> > > to figure out who dirtied the page.
> > > 
> > 
> > Is this bad ?
> > ==
> 
> Sounds like an interesting idea. I am primarily concered about the radix
> tree node size increase. Not sure how big a concern this is.
> 
> Also tracking is useful for two things.
> 
> - Proportinal IO
> - IO throttling
> 
> For proportional IO, anyway we have to use it with memory controller to
> control per cgroup dirty ratio so storing info in page_cgroup should
> not hurt. 
> 

dirty-ratio for memcg will be implemented. It's definitely necessary.

> The only other case where dependence on page_cgroup hurts is IO throttling
> where IO controller does not really need memory cgroup controller (I hope
> so). But we are still not sure if throttling IO at device level is a
> good idea and how to resolve issues related to priority inversion.
> 
Yes, that's priority inversion is my concern.

Thanks,
-Kame

