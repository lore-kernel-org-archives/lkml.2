Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2JIW6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab2JIW6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:58:44 -0400
Date: Tue, 9 Oct 2012 15:58:36 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121009225836.GU26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009224428.GH29494@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not if we decouple the ringbuffer size from max_requests.

Hmm, interesting.

> This would be useful to do anyways because right now, allocating a kiocb
> has to take a global refcount and check head and tail in the ringbuffer
> just so it can avoid overflowing the ringbuffer.

I'm not sure what you mean by a 'global refcount'.. do you mean the
per-mm ctx_lock?

> If we change aio_complete() so that if the ringbuffer is full then the
> kiocb just goes on a linked list - we can size the ringbuffer so this
> doesn't happen normally and avoid the global synchronization in the fast
> path.

How would completion events make their way from the list to the ring if
an app is only checking the ring for completions from userspace?

- z
