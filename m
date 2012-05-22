Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab2EVPGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab2EVPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:06:14 -0400
Date: Tue, 22 May 2012 11:06:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] block/throttle: Add IO throttled information in blkcg.
Message-ID: <20120522150606.GH3045@redhat.com>
References: <1337674236-2896-1-git-send-email-tm@tao.ma>
 <20120522111111.GE3045@redhat.com>
 <4FBBA63B.1090401@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBBA63B.1090401@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:44:11PM +0800, Tao Ma wrote:
> Hi Vivek,
> 	Thanks for the quick response.
> On 05/22/2012 07:11 PM, Vivek Goyal wrote:
> > On Tue, May 22, 2012 at 04:10:36PM +0800, Tao Ma wrote:
> >> From: Tao Ma <boyu.mt@taobao.com>
> >>
> >> Currently, if the IO is throttled by io-throttle, the SA has no idea of
> >> the situation and can't report it to the real application user about
> >> that he/she has to do something. So this patch adds a new interface
> >> named blkio.throttle.io_throttled which indicates how many IOs are
> >> currently throttled.
> > 
> > If the only purpose is to know whether IOs are being throttled, why
> > not just scan for the rules and see if respective device has any
> > throttling rules or not.
> Sorry, but setting a throttling rules doesn't mean the IOs are
> throttled, right? So scanning doesn't work here IMHO.

It means IOs will be throttled if you cross a certain rate. But yes, it
does not give any information that if at time T if there are any bios
throttled in the queue or not.

> > 
> > Even if you introduce this interface, you will end up scanning for
> > throttled ios against that particular device. And if IO is not happening
> > at that moment or if IO rate is not exceeding the rate limit, there
> > might not be any throttled ios and one might get misled.
> Oh, no actually in a *clound computing* environment, it is really
> useful, not misled. So let me describe it in more detail. Our product
> system will limit every instance to an approximate number at first, and
> then watch out the IOs being throttled. If these numbers is high, it can:
> 1) Shout loudly to the application programmer about the abuse if he
> sends out too much IO requests.
> 2) If it is not too much and some other instances are not active, adjust
> the throttled ratio so that this instance can work much faster.

Ok, so you want to use this more as "congestion" parameter which tells at
a given moment how busy the queue is, or in this instance how many IOs
are backlogged in a cgroup due to throttling limits.

I guess, it is not a bad idea to export this stat then. Will
"blkio.throttle.queued" be a better name to reflect that how many bios
are currently queued in throttling layer of request queue.

Thanks
Vivek
