Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1C2RzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:55:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1C2RzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:55:13 -0400
Date: Tue, 29 Mar 2011 13:54:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE (was: Re:
 elevator private data for REQ_FLUSH)
Message-ID: <20110329175458.GE24485@redhat.com>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:13:05AM -0400, Jeff Moyer wrote:
> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > OK, I came up with the following patch.
> >
> > Jens, this is just a natural cleanup given the code that resulted from
> > the flush-merge and onstack plugging changes coming together.
> >
> >
> > From: Mike Snitzer <snitzer@redhat.com>
> > Subject: block: eliminate ELEVATOR_INSERT_REQUEUE
> >
> > elv_insert() no longer has a need to differentiate between
> > ELEVATOR_INSERT_REQUEUE and ELEVATOR_INSERT_FRONT.  The onstack plugging
> > changes eliminated the need to avoid unplugging the queue (via
> > ELEVATOR_INSERT_REQUEUE).
> >
> > Also, in blk_insert_flush(), use elv_insert() with ELEVATOR_INSERT_FRONT
> > rather than open-coding the equivalent.
> 
> What you change by doing the call to elv_insert is that now the request
> will have REQ_SOFTBARRIER set.  I don't think that affects anything,
> though (I checked).  The rest looks pretty straight-forward.

What is the significance of REQ_SOFTBARRIER? Why it should be set for all
INSERT_FRONT and requeue requests.

With flush logic we got rid of all hardbarriers and hence there is no
notion of ordering as such. One has to wait for request to finish to
enforce ordering.

Should we get rid of softbarriers too?

Thanks
Vivek
