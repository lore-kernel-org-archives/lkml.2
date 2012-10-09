Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2JIWcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab2JIWcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:32:19 -0400
Date: Tue, 9 Oct 2012 15:32:10 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121009223210.GR26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009213111.GE29494@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it is measurable I'll take another stab at using memory from
> __get_free_pages() for the ringbuffer. That really would be the ideal
> solution.

No, then you'll run into high order allocation failures with rings that
don't fit in a single page.

> The other reason I wanted to do this was for the aio attributes stuff -
> for return values, I think the only sane way is for the return values to
> go in the ringbuffer, which means records are no longer fixed size so
> dealing with pages is even more of a pain.

Then let's see that, please.

And can we please stop calling them attributes?  They're inputs and
outputs that change behaviour -- they're interfaces.

And no, just for the record, I don't think generic packed variable size
structs are worth the trouble.

If we're going to do a generic interface extension mechanism then we
should put it in its own well thought out system calls, not staple it on
to the side of aio because it's there.  It's a really crummy base to
work from.

- z
