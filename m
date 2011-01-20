Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1ATRab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:30:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1ATRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:30:30 -0500
Date: Thu, 20 Jan 2011 12:30:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@tglx.de>
Subject: Re: [PATCH] RFC: abstract access to xtime_lock into a set of inline
 functions
Message-ID: <20110120173029.GA26121@infradead.org>
References: <1295543648-13788-1-git-send-email-torbenh@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295543648-13788-1-git-send-email-torbenh@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 06:14:08PM +0100, Torben Hohn wrote:
> the -rt patches change the xtime_lock to a raw_seqlock_t
> so a pretty huge portion of the patch deals with changing
> the locking functions.
> 
> this commit uses inline functions, to hide the type
> of the lock.

That's not how kernel code usually works.

> -	write_seqlock(&xtime_lock);
> +	xtime_write_seqlock();
>  	do_timer(1);
> -	write_sequnlock(&xtime_lock);
> +	xtime_write_sequnlock();

However there's a pretty clear pattern of taking xtime_lock, calling
do_timer and then releasing.  A useful thing you could do is to rename
do_timer to do_timer_locked and make do_timer take and release
xtime_lock in one place.

