Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2JIVbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:31:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43621 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab2JIVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:31:15 -0400
Date: Tue, 9 Oct 2012 14:31:11 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121009213111.GE29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009182949.GO26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:29:49AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:19PM -0700, Kent Overstreet wrote:
> > It simplifies a lot of stuff if the ringbuffer is contiguously mapped
> > into kernel space, and we can delete a lot of code - in particular, this
> > is useful for converting read_events() to cmpxchg.
> 
> 1) I'm concerned that Our Favourite Database Benchmarkers will see an
> effect of having more TLB pressure from that mapping.  kmap_atomic()
> should be cheaper.  We'll need to measure the difference.

If it is measurable I'll take another stab at using memory from
__get_free_pages() for the ringbuffer. That really would be the ideal
solution.

The other reason I wanted to do this was for the aio attributes stuff -
for return values, I think the only sane way is for the return values to
go in the ringbuffer, which means records are no longer fixed size so
dealing with pages is even more of a pain.
