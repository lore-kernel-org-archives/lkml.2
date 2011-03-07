Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1CGO2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:28:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CGO2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:28:37 -0500
Date: Mon, 7 Mar 2011 09:28:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6 v5.1] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
Message-ID: <20110307142828.GA9540@redhat.com>
References: <4D6201A3.70301@cn.fujitsu.com>
 <4D64788F.6040408@cn.fujitsu.com>
 <20110224181140.GE18494@redhat.com>
 <4D670C14.9040504@cn.fujitsu.com>
 <20110227231618.GA1014@redhat.com>
 <20110228001544.GA2762@redhat.com>
 <4D6E1556.5060905@cn.fujitsu.com>
 <4D706BC3.9090900@cn.fujitsu.com>
 <20110304191458.GE5466@redhat.com>
 <4D71C718.3020800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D71C718.3020800@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 01:16:08PM +0800, Gui Jianfeng wrote:

[..]
> >> This bug seems being introduced in commmit 763414b in for-next branch when
> >> merging for-2.6.39/core branch.
> >> Would you apply the above patch?
> >>
> >> Vivek, can you try the patchset again with this fix? It works fine for me now.
> > 
> > Gui,
> > 
> > Ok, I ran iostest with this fix and it seems to have worked. I need to run
> > it for some more time. And I also need to spend more time reviewing your
> > patchset. There are so many details to it. Soon I will spare some time
> > to review it more and also test it bit more.
> 
> Vivek,
> 
> Ok, thanks.
> 
> > 
> > Of the top of my head I have one concern.
> > 
> > - How to map iopriority to weights. I am thinking that currently weight
> >   range is 100-1000. If we decide to extend the range in current scheme,
> >   it will change the ioprio entity weight also and effectively the
> >   service differentiation between ioprio level will change. I am
> >   wondering if this is a concern and how cpu scheduler has managed it
> 
> Isn't it enought for ten times of weight difference? The old ioprio scheme
> has only 4.5 times service difference. So I think we don't need to extend
> the range for the time being.

Well, never say never. I think google guys are already using minimum
weight of 10. So don't rule it out.

Secondly, because we might not idle all the time the effective service
differentiation might be much less than a factor of 10. In that case
to get effective 10, one might have to go for wider range of weights.

Thanks
Vivek
