Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab0HFA22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:28:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024Ab0HFA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:28:23 -0400
Date: Thu, 5 Aug 2010 17:27:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
        david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and 
 pages_entered_writeback
Message-Id: <20100805172711.87c802ca.akpm@linux-foundation.org>
In-Reply-To: <20100806091548.31ED.A69D9226@jp.fujitsu.com>
References: <20100806084928.31DE.A69D9226@jp.fujitsu.com>
	<AANLkTimD4jkkPpnhQhR+OF=6=dWV2dJj4M_DGfAmHgRQ@mail.gmail.com>
	<20100806091548.31ED.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Aug 2010 09:18:59 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Thu, Aug 5, 2010 at 4:56 PM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > /proc/vmstat already have both.
> > >
> > > cat /proc/vmstat |grep nr_dirty
> > > cat /proc/vmstat |grep nr_writeback
> > >
> > > Also, /sys/devices/system/node/node0/meminfo show per-node stat.
> > >
> > > Perhaps, I'm missing your point.
> > 
> > These only show the number of dirty pages present in the system at the
> > point they are queried.
> > The counter I am trying to add are increasing over time. They allow
> > developers to see rates of pages being dirtied and entering writeback.
> > Which is very helpful.
> 
> Usually administrators get the data two times and subtract them. Isn't it sufficient?
> 

Nope.  The existing nr_dirty is "number of pages dirtied since boot"
minus "number of pages cleaned since boot".  If you do the
wait-one-second-then-subtract thing on nr_dirty, the result is
dirtying-bandwidth minus cleaning-bandwidth, and can't be used to
determine dirtying-bandwidth.

I can see that a graph of dirtying events versus time could be an
interesting thing.  I don't see how it could be obtained using the
existing instrumentation.  tracepoints, probably..

