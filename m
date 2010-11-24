Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0KXKvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:51:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55772 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab0KXKvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:51:09 -0500
Subject: Re: [PATCH 03/13] writeback: per-task rate limit on
 balance_dirty_pages()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124104331.GA6096@localhost>
References: <20101117042720.033773013@intel.com>
	 <20101117042849.650810571@intel.com> <1290594187.2072.440.camel@laptop>
	 <20101124104331.GA6096@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 11:49:28 +0100
Message-ID: <1290595768.2072.443.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 18:43 +0800, Wu Fengguang wrote:
> On Wed, Nov 24, 2010 at 06:23:07PM +0800, Peter Zijlstra wrote:
> > On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> > > +       if (unlikely(current->nr_dirtied >= current->nr_dirtied_pause ||
> > > +                    bdi->dirty_exceeded)) {
> > > +               balance_dirty_pages(mapping, current->nr_dirtied);
> > > +               current->nr_dirtied = 0;
> > >         } 
> > 
> > Was it a conscious choice to use
> >   current->nr_dirtied = 0
> > over 
> >   current->nr_dirtied -= current->nr_dirtied_pause
> > ?
> > 
> > The former will cause a drift in pause times due to truncation of the
> > excess.
> 
> It should be fine in either way, as long as the "truncated" number is
> passed to balance_dirty_pages():
> 
> +               balance_dirty_pages(mapping, current->nr_dirtied);
> +               current->nr_dirtied = 0;
> 
> or
> 
> +               balance_dirty_pages(mapping, current->nr_dirtied_pause);
> +               current->nr_dirtied -= current->nr_dirtied_pause;

ok, just wanted to make sure you'd considered it.

