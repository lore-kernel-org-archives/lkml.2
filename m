Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0I0Dag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 23:30:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab0I0Daf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 23:30:35 -0400
Date: Sun, 26 Sep 2010 23:30:31 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <axboe@kernel.dk>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] block: prevent merges of discard and write requests
Message-ID: <20100927033030.GR13116@bombadil.infradead.org>
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
 <4C9DD1B0.9020902@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9DD1B0.9020902@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:40:48PM +0200, Jens Axboe wrote:
> On 2010-09-25 12:36, Adrian Hunter wrote:
> > Add logic to prevent two I/O requests being merged if
> > only one of them is a discard.  Ditto secure discard.
> > 
> > Without this fix, it is possible for write requests
> > to transform into discard requests.  For example:
> > 
> >   Submit bio 1 to discard 8 sectors from sector n
> >   Submit bio 2 to write 8 sectors from sector n + 16
> >   Submit bio 3 to write 8 sectors from sector n + 8
> > 
> > Bio 1 becomes request 1.  Bio 2 becomes request 2.
> > Bio 3 is merged with request 2, and then subsequently
> > request 2 is merged with request 1 resulting in just
> > one I/O request which discards all 24 sectors.
> 
> Wow, that's a disaster. We can now have requests in the
> same direction and of the same type (fs), but not mergeable.
> 
> I would move the check up above the position calculations.
> I will apply this and upstream it right away. Thanks a lot!
> 

Jens, is this (the REQ_DISCARD hunk) required for stable as well? It
appears there's not much change relating to merging requests between
HEAD and v2.6.35, so I assume it is?

--Kyle
