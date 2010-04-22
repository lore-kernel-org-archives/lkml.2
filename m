Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0DVPx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:53:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:51322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0DVPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:53:57 -0400
Date: Thu, 22 Apr 2010 17:53:59 +0200
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: CFQ read performance regression
Message-ID: <20100422155358.GE5805@quack.suse.cz>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
 <1271931809.24780.387.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271931809.24780.387.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-04-10 12:23:29, Miklos Szeredi wrote:
> > >
> > > This is on a vanilla 2.6.34-rc4 kernel with two tunables modified:
> > >
> > > read_ahead_kb=512
> > > low_latency=0 (for CFQ)
> > You should get much better throughput by setting
> > /sys/block/_your_disk_/queue/iosched/slice_idle to 0, or
> > /sys/block/_your_disk_/queue/rotational to 0.
> 
> slice_idle=0 definitely helps.  rotational=0 seems to help on 2.6.34-rc
> but not on 2.6.32.
> 
> As far as I understand setting slice_idle to zero is just a workaround
> to make cfq look at all the other queues instead of serving one
> exclusively for a long time.
  Yes, basically it disables idling (i.e., waiting whether a thread sends
more IO so that we can get better IO locality).

> I have very little understanding of I/O scheduling but my idea of what's
> really needed here is to realize that one queue is not able to saturate
> the device and there's a large backlog of requests on other queues that
> are waiting to be served.  Is something like that implementable?
  I see a problem with defining "saturate the device" - but maybe we could
measure something like "completed requests / sec" and try autotuning
slice_idle to maximize this value (hopefully the utility function should
be concave so we can just use "local optimization").

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
