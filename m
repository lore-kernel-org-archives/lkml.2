Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab2CSLc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:32:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53338
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939Ab2CSLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:32:55 -0400
Date: Mon, 19 Mar 2012 07:32:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ulrich Drepper <drepper@akkadia.org>, arnd@arndb.de,
        davem@davemloft.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: Re: [PATCH] Install kernel-page-flags.h
Message-ID: <20120319113241.GA13991@infradead.org>
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
 <20120314075842.GA337@infradead.org>
 <CACVxJT-73diTvBhDxZ=7VUz2BqaRetdnCUGk3hh+_7gyWXB6Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT-73diTvBhDxZ=7VUz2BqaRetdnCUGk3hh+_7gyWXB6Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 12:40:36PM +0200, Alexey Dobriyan wrote:
> >> Programs using /proc/kpageflags need to know about the various flags. ??The
> >> <linux/kernel-page-flags.h> provides them and the comments in the file
> >> indicate that it is supposed to be used by user-level code. ??But the file
> >> is not installed.
> >>
> >> The patch below installs the headers and marks the unstable flags as
> >> out-of-bounds.
> >
> > I don't think this is a good idea at all. ??Let's shoot the person who
> > added that braindead interface ASAP, and replace it with one printing
> > the flags in ASCII format.
> 
> ASCII sucks.
> This interface is not for humans.

But we still can't lock down the page flags for a user interface - they
are a very scare resource and we can't afford to keep them stable due
to userspace poking into internals.

I guess the best we can do is to have a translation table for kernel
internal to external documented flags.  Once you export the header with
the meanings it's time to add that table, even if it starts out as a 1:1
mapping.
