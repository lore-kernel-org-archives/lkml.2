Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0JQApS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:45:18 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33160 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0JQApQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:45:16 -0400
Date: Sat, 16 Oct 2010 20:45:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101017004515.GB1614@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016171213.GC3240@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:12:13AM +1100, Nick Piggin wrote:
> > With the changes Dave implemented based on my suggestions we now have
> > an abstract locked hash list data type.  It has the normal hash list
> > operations plus lock/unlock operations.
> 
> That's ugly. It just hides the locking. If a bit of casting bothers
> you then put it in a function where it is used like I did.

Exposing the implementation details of which bit of a pointer can
be used as lock when cast to an unsigned long to every user of an
abstract type is what I would consider ugly, and on similar issues
I've certainly not been the only one.


> >  So if e.g. the -rt folks need
> > real locks in there there is one single place they need to touch
> > instead of every user.  Similarly if we want to add lockdep support
> > there is just one place to touch.
> 
> It's unnecessary.

What, lockdep support?
