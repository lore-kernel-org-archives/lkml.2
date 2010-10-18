Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab0JRQVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:21:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab0JRQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:21:17 -0400
Date: Mon, 18 Oct 2010 12:21:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101018162105.GB9571@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
 <20101017022539.GA3317@amd>
 <87iq0za32l.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iq0za32l.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 06:16:50PM +0200, Andi Kleen wrote:
> > Hiding the type of lock, and hiding the fact that it sets the low bit?
> > I don't agree. We don't have synchronization in our data structures,
> > where possible, because it is just restrictive or goes wrong when people
> > don't think enough about the locking.
> 
> I fully agree. The old skb lists in networking made this mistake
> long ago and it was a big problem, until people essentially stopped 
> using it (always using __ variants) and it was eventually removed.
> 
> Magic locking in data structures is usually a bad idea.

Err, there is no implicit locking in the calls to hlist_*.  There
is just two small wrappers for the bit-lock/unlock so that the callers
don't have to know how the lock is overloaded onto the pointer in the
list head.  

