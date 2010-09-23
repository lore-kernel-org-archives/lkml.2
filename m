Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab0IWGk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:40:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0IWGk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:40:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
Date: Thu, 23 Sep 2010 08:40:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
References: <1284815371-5843-1-git-send-email-arnd@arndb.de> <201009212209.51956.arnd@arndb.de> <Pine.LNX.4.64.1009222037500.14029@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1009222037500.14029@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230840.11724.arnd@arndb.de>
X-Provags-ID: V02:K0:NEm5tbY6M9zQJFZ22KnVVMU+wNp8oXhH0KKsG+1B8Pt
 JciuKSlOM1QzcLjc8BQJwwUmjaz+RS6rCRUjE+F+xDhPaxyu3m
 4kB/y/AndzL6NMcKHKWUQezJEAyICr/E6DfiMiGV1VmU/PtLZs
 9MjUVnbQJ40VJBe+1tn9Wzm1P1A0IVLnURwWi3W8TWViuh4PHm
 +ml3JCL/bIFhS8QvuNUvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 September 2010 05:42:49 Sage Weil wrote:
> Okay, the lock/unlock_flocks() stubs on in Linus' tree now, and the Ceph 
> for-next branch is rebased and updated to fix the memory allocations and 
> switch to the new interface.

Ok. I'll put the patches for the other stuff (everything but ceph and lockd)
in my bkl/vfs branch then.

> Unfortunately you still need to #include smp_lock.h for now since the 
> stubs are just #defines, so we'll need to remember to clean that up later.

Don't worry about that. We have a few of those leftover ones, so we can
do a single patch removing them all before one day removing the header
file itself.

	Arnd
