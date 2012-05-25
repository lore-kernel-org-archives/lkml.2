Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2EYPSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab2EYPSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:18:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87k400i9y1.fsf@tucsk.pomaz.szeredi.hu>
References: <87k400i9y1.fsf@tucsk.pomaz.szeredi.hu> <1335357857-16416-1-git-send-email-miklos@szeredi.hu> <6422.1337872046@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 00/16] vfs: atomic open v4 (part 1)
Date: Fri, 25 May 2012 16:18:39 +0100
Message-ID: <13673.1337959119@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > For instance, in lookup_open(), you call security_path_mknod() prior to
> > calling vfs_create(), but you don't call it prior to calling atomic_open()
> > or in, say, nfs_atomic_open().
> 
> We call security_path_mknod() before ->atomic_open() in may_o_create().

Okay.

> > I'm also wondering if you're missing an audit_inode() call in the if
> > (created) path after the retry_lookup label.
> 
> There's no audit_inode() on the created dentry neither in the original
> code nor in the modified code.
> 
> But that may be a bug regardless, it's just independent of my changes.
> At least AFAICS.

Fair enough.

David
