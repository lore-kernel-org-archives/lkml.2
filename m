Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2EYO63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:58:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43447 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2EYO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:58:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
	<6422.1337872046@redhat.com>
Date: Fri, 25 May 2012 16:58:46 +0200
In-Reply-To: <6422.1337872046@redhat.com> (David Howells's message of "Thu, 24
	May 2012 16:07:26 +0100")
Message-ID: <87k400i9y1.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> I've been looking at your patches when they're all applied, and I suspect
> you're missing some security calls.
>
> For instance, in lookup_open(), you call security_path_mknod() prior to
> calling vfs_create(), but you don't call it prior to calling atomic_open() or
> in, say, nfs_atomic_open().

We call security_path_mknod() before ->atomic_open() in may_o_create().

>   You do need to, however, though I can see it's
> difficult to work out where.  Is it possible to call it if O_CREAT is
> specified and d_inode is NULL right before calling atomic_open()?
>
> I'm also wondering if you're missing an audit_inode() call in the if (created)
> path after the retry_lookup label.

There's no audit_inode() on the created dentry neither in the original
code nor in the modified code.

But that may be a bug regardless, it's just independent of my changes.
At least AFAICS.

Thanks,
Miklos
