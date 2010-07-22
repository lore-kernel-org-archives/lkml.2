Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab0GVPdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 11:33:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0GVPdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 11:33:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100722145738.GA5752@amd>
References: <20100722145738.GA5752@amd> <20100722041554.GB3446@amd> <27282.1279058150@redhat.com> <30811.1279802187@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Add a dentry op to handle automounting rather than abusing follow_link
Date: Thu, 22 Jul 2010 16:33:13 +0100
Message-ID: <20204.1279812793@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> I think you have it the wrong way around. If you wanted to call the
> automount code, you would have incremented d_mounted.

Why?  d_mounted indicates how many things are mounted on a dentry, doesn't it?
Before the automounter is invoked there isn't anything mounted there.

> Those that don't care wouldn't set ->follow_mount though.  Following a mount
> is a fairly heavy operation already, it does take a global lock (before vfs
> scalability patches, anyway).

I wonder if we could do it with a lock on vfsmount instead and use mnt_mounts
to find it.

> I like the flexibility of doing one's own ->follow_mount, although Al might
> object to allowing filesystems to follow mounts in ways that are not
> published to the core namespace structures.

But why would you want to delegate mountpoint traversal to the filesystem?

David
