Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab0FPSyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:54:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:35137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab0FPSyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:54:35 -0400
Subject: Re: [RFC PATCH] mm: let the bdi_writeout fraction respond more
 quickly
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <1276526681.1980.89.camel@castor.rsk>
References: <1276523894.1980.85.camel@castor.rsk>
	 <1276526681.1980.89.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 20:54:26 +0200
Message-ID: <1276714466.1745.625.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 15:44 +0100, Richard Kennedy wrote:
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 2fdda90..315dd04 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -144,7 +144,7 @@ static int calc_period_shift(void)
> >       else
> >               dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> >                               100;
> > -     return 2 + ilog2(dirty_total - 1);
> > +     return ilog2(dirty_total - 1) - 4;
> >  } 

IIRC I suggested similar things in the past and all we needed to do was
find people doing the measurements on different bits of hardware or so..

I don't have any problems with the approach, all we need to make sure is
that we never return 0 or a negative number (possibly ensure a minimum
positive shift value).


