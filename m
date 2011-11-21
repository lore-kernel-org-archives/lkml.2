Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1KUMAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:00:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:4843 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1KUMAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:00:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77517383"
Date: Mon, 21 Nov 2011 20:00:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/8] readahead stats/tracing, backwards prefetching and
 more
Message-ID: <20111121120027.GD8895@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121095638.GA5084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121095638.GA5084@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:56:38PM +0800, Christoph Hellwig wrote:
> On Mon, Nov 21, 2011 at 05:18:19PM +0800, Wu Fengguang wrote:
> > Andrew,
> > 
> > I'm getting around to pick up the readahead works again :-)
> > 
> > This first series is mainly to add some debug facilities, to support the long
> > missed backwards prefetching capability, and some old patches that somehow get
> > delayed (shame me).
> > 
> > The next step would be to better handle the readahead thrashing situations.
> > That would require rewriting part of the algorithms, this is why I'd like to
> > keep the backwards prefetching simple and stupid for now.
> > 
> > When (almost) free of readahead thrashing, we'll be in a good position to lift
> > the default readahead size. Which I suspect would be the single most efficient
> > way to improve performance for the large volumes of casually maintained Linux
> > file servers.
> 
> Btw, if you work actively in that area I have a todo list item I was
> planning to look into sooner or later:  instead of embedding the ra
> state into the struct file allocate it dynamically.  That way files that
> either don't use the pagecache, or aren't read from won't need have to
> pay the price for increasing struct file size, and if we have to we
> could enlarge it more easily.

Agreed. That's good to have, please allow me to move it into my todo list :)

> Besides removing f_version in the common
> struct file and also allocting f_owner separately that seem to be the
> easiest ways to get struct file size down.

Yeah, there seems no much code accessing fown_struct.
I may consider that when I'm at file_ra_state, but no promise ;)

Thanks,
Fengguang
