Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab1CDLBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:01:45 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57537 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1CDLBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:01:43 -0500
Message-ID: <4D70C695.4040205@kernel.dk>
Date: Fri, 04 Mar 2011 12:01:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: Per iocontext request descriptor limits (Was: Re: RFC: default
  group_isolation to 1, remove option)
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com> <20110301142002.GB25699@redhat.com> <4D6F0ED0.80804@kernel.dk> <20110303153007.GF16720@redhat.com> <4D6FB751.3010608@kernel.dk> <20110303165717.GA19527@redhat.com> <20110303180328.GH16720@redhat.com>
In-Reply-To: <20110303180328.GH16720@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-03 19:03, Vivek Goyal wrote:
> On Thu, Mar 03, 2011 at 11:57:17AM -0500, Vivek Goyal wrote:
> 
> [..]
>>> For now it's not a complicated effort, I already have a patch for this.
>>> If page tracking needs extra complexity, it'll have to remain in the
>>> page tracking code.
>>
>> Great. I am hoping once you get some free time, you will cleanup and post
>> that patch.
> 
> Hmmm..., Now I got interested in this stuff. In case you would like to see
> your patch to be in and finding it hard to find time to clean it up, I can
> do that and repost and also fix any bugs.

I did an initial run on the plane:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-2.6.39/ioc-rq-alloc

Not tested at all, so there are likely a few bugs. Congestion is gone,
we'll need to consider that. Before the device was either congested or
not congested, now the question to ask would be "is the device congested
for ME" as the answer will depend on who is asking.

-- 
Jens Axboe

