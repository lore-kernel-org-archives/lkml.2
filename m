Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0ICMsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:48:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0ICMse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:48:34 -0400
Date: Fri, 3 Sep 2010 08:48:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
Message-ID: <20100903124815.GA12694@redhat.com>
References: <20100901175830.GC22149@redhat.com>
 <4C80C4FF.5090409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C80C4FF.5090409@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 05:50:55PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > Hi,
> > 
> > Currently CFQ provides the weight based proportional division of bandwidth.
> > People also have been looking at extending block IO controller to provide
> > throttling/max bandwidth control.
> > 
> > I have started to write the support for throttling in block layer on 
> > request queue so that it can be used both for higher level logical
> > devices as well as leaf nodes. This patch is still work in progress but
> > I wanted to post it for early feedback.
> > 
> > Basically currently I have hooked into __make_request() function to 
> > check which cgroup bio belongs to and if it is exceeding the specified
> > BW rate. If no, thread can continue to dispatch bio as it is otherwise
> > bio is queued internally and dispatched later with the help of a worker
> 
> Hi Vivek,
> 
> I'd like to give it a try.
> In what manner the worker dispatch bios? FIFO? I have yet gone throught the patch.
> 

Hi Gui,

Yes, the dispatch of throttled bios is FIFO with-in group.

Thanks
Vivek
