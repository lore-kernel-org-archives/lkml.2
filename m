Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab2EXPIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:08:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177Ab2EXPID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:08:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
Date: Thu, 24 May 2012 16:07:26 +0100
Message-ID: <6422.1337872046@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been looking at your patches when they're all applied, and I suspect
you're missing some security calls.

For instance, in lookup_open(), you call security_path_mknod() prior to
calling vfs_create(), but you don't call it prior to calling atomic_open() or
in, say, nfs_atomic_open().  You do need to, however, though I can see it's
difficult to work out where.  Is it possible to call it if O_CREAT is
specified and d_inode is NULL right before calling atomic_open()?

I'm also wondering if you're missing an audit_inode() call in the if (created)
path after the retry_lookup label.

David
