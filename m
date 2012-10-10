Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2JJPRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:17:37 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:54821 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab2JJPRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:17:36 -0400
Date: Wed, 10 Oct 2012 07:03:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121010110356.GA11468@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	Zach Brown <zab@redhat.com>, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009213700.GF29494@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:37:00PM -0700, Kent Overstreet wrote:
> > Honestly: I wouldn't bother.  Nothing of consequence uses cancel.
> > 
> > I have an RFC patch series that tears it out.  Let me polish that up
> > send it out, I'll cc: you.
> 
> Even better :)
> 
> I've been looking at aio locking the past few days, and I was getting
> ready to write something up about cancellation to the lists.

I can definitely think of use cases (inside of Google) where we could
really use aio_cancel.  The issue is it's hard use it safely (i.e., we
need to know whether the file system has already extended the file
before we can know whether or not we can safely cancel the I/O).

> Short version, supporting cancellation without global sychronization is
> possible but it'd require help from the allocator.

Well, we would need some kind of flag to indicate whether cancellation
is possible, yes.  But if we're doing AIO to a raw disk, or we're
talking about a read request, we wouldn't need any help from the
file system's block allocator.

And maybe the current way of doing things isn't the best way.  But it
would be nice if we didn't completely give up on the functionality of
aio_cancel.

						- Ted
