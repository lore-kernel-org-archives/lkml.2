Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2JJVVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab2JJVU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:20:59 -0400
Date: Wed, 10 Oct 2012 14:20:51 -0700
From: Zach Brown <zab@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Kent Overstreet <koverstreet@google.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121010212051.GD6371@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
 <20121010110356.GA11468@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010110356.GA11468@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And maybe the current way of doing things isn't the best way.  But it
> would be nice if we didn't completely give up on the functionality of
> aio_cancel.

I sympathize, but the reality is that the current infrastructure
is very bad and no one is using it.

It's not like we're getting rid of the syscall.  I'll be behaving
exactly as it does today: returning the error code that indicates that
cancellation failed because it lost the race with completion.  Every
caller has to cope with that to use cancel safely.

So if someone eventually implements iocb cancel safely we'll be able to
plumb it back under the aio syscalls.  But until that day I see no
reason to carry around buggy infrastructure that is only slowing down
the fast path.

- z

