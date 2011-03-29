Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1C2OTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab1C2OTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:19:03 -0400
Date: Tue, 29 Mar 2011 10:18:53 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110329141853.GA23949@redhat.com>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <4D91C8E7.5070205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91C8E7.5070205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29 2011 at  7:56am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2011-03-29 00:15, Mike Snitzer wrote:
> > On Mon, Mar 28 2011 at  4:23am -0400,
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> On Sat, Mar 26, 2011 at 12:21:56AM -0400, Mike Snitzer wrote:
> >>> Should blk_kick_flush() process the flush request without calling
> >>> elv_insert() -- like is done with open coded list_add() in
> >>> blk_insert_flush()?
> >>>
> >>> Or should blk_insert_flush() use elv_insert() with
> >>> ELEVATOR_INSERT_REQUEUE too? 
> >>
> >> Hmmm... I would prefer the latter.  Given that INSERT_REQUEUE and
> >> FRONT are no longer different, it would probably be better to use
> >> FRONT tho.  The only reason REQUEUE is used there is to avoid kicking
> >> the queue from elv_insert(), which is gone now.
> > 
> > OK, I came up with the following patch.
> > 
> > Jens, this is just a natural cleanup given the code that resulted from
> > the flush-merge and onstack plugging changes coming together.
> 
> That looks nice and clean. What kind of testing has been done?

I successfully tested it with that fsync-heavy ffsb workload (xfs on
mpath device).

Mike
