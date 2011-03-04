Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227Ab1CDVcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:32:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167Ab1CDVb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:31:59 -0500
Date: Fri, 4 Mar 2011 16:31:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: Per iocontext request descriptor limits (Was: Re: RFC: default
 group_isolation to 1, remove option)
Message-ID: <20110304213147.GH5466@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
 <20110303153007.GF16720@redhat.com>
 <4D6FB751.3010608@kernel.dk>
 <20110303165717.GA19527@redhat.com>
 <20110303180328.GH16720@redhat.com>
 <4D70C695.4040205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70C695.4040205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 12:01:41PM +0100, Jens Axboe wrote:
> On 2011-03-03 19:03, Vivek Goyal wrote:
> > On Thu, Mar 03, 2011 at 11:57:17AM -0500, Vivek Goyal wrote:
> > 
> > [..]
> >>> For now it's not a complicated effort, I already have a patch for this.
> >>> If page tracking needs extra complexity, it'll have to remain in the
> >>> page tracking code.
> >>
> >> Great. I am hoping once you get some free time, you will cleanup and post
> >> that patch.
> > 
> > Hmmm..., Now I got interested in this stuff. In case you would like to see
> > your patch to be in and finding it hard to find time to clean it up, I can
> > do that and repost and also fix any bugs.
> 
> I did an initial run on the plane:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-2.6.39/ioc-rq-alloc
> 
> Not tested at all, so there are likely a few bugs. Congestion is gone,
> we'll need to consider that. Before the device was either congested or
> not congested, now the question to ask would be "is the device congested
> for ME" as the answer will depend on who is asking.


Thanks Jens. I was having a quick look and noticed that ioc->count[] state
is global across queues. I guess what we want is to keep track of ioc
state per queue (something like cfq_io_context). By maintaining per device
state in ioc, we can also tell whether a particular ioc is congested or
not on a specific device.

Thanks
Vivek
