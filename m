Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab0HFAo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:44:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52415 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0HFAoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:44:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and  pages_entered_writeback
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Rubin <mrubin@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
In-Reply-To: <20100805172711.87c802ca.akpm@linux-foundation.org>
References: <20100806091548.31ED.A69D9226@jp.fujitsu.com> <20100805172711.87c802ca.akpm@linux-foundation.org>
Message-Id: <20100806093312.31F9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  6 Aug 2010 09:44:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri,  6 Aug 2010 09:18:59 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > On Thu, Aug 5, 2010 at 4:56 PM, KOSAKI Motohiro
> > > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > /proc/vmstat already have both.
> > > >
> > > > cat /proc/vmstat |grep nr_dirty
> > > > cat /proc/vmstat |grep nr_writeback
> > > >
> > > > Also, /sys/devices/system/node/node0/meminfo show per-node stat.
> > > >
> > > > Perhaps, I'm missing your point.
> > > 
> > > These only show the number of dirty pages present in the system at the
> > > point they are queried.
> > > The counter I am trying to add are increasing over time. They allow
> > > developers to see rates of pages being dirtied and entering writeback.
> > > Which is very helpful.
> > 
> > Usually administrators get the data two times and subtract them. Isn't it sufficient?
> > 
> 
> Nope.  The existing nr_dirty is "number of pages dirtied since boot"
> minus "number of pages cleaned since boot".  If you do the
> wait-one-second-then-subtract thing on nr_dirty, the result is
> dirtying-bandwidth minus cleaning-bandwidth, and can't be used to
> determine dirtying-bandwidth.

Technically, yes. I meant, _now_, typical administrators are using the 
subtraction.
Do you mean this is wrong? or do you mean you have another use case?

Just curious.


> I can see that a graph of dirtying events versus time could be an
> interesting thing.  I don't see how it could be obtained using the
> existing instrumentation.  tracepoints, probably..

I think it depend on frequency of the usecase. If the usecase is enouth
major, convenience way (e.g. /proc/vmstat) is very helpful.

probably, I haven't understand the usecase of this feature.



