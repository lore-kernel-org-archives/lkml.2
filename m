Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1CAFOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:14:31 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41032 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938Ab1CAFO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:14:29 -0500
X-Sasl-enc: KWUcR+yszjFN2xCA4kxFkWtjhe1whFF/UstzJxvzQr8E 1298956468
Subject: Re: [PATCH 0/4] more on vfs-scale and vfs-automount
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 13:14:22 +0800
Message-ID: <1298956462.3726.33.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 12:56 +0800, Ian Kent wrote:
> I've put quite a bit of time into testing 2.6.38-rc and, given the
> time frame, and update is needed. The included patch series much
> improves the behaviour of autofs under load.

Sorry Al, I didn't yet test against the namei patches you provided.
This was against rc6.

> 
> I first thought the dentry leak you found was not the cause of the
> BUG() I was seeing but that appears to not be the case. I'm not
> seeing the BUG() at shutdown when umounting any more.
> 
> I am still seeing occassional incorrect ENOENT returns. They must be
> comming from the VFS or the daemon as I've changed almost all the
> ENOENT returns in the autofs module to identify where it's comming
> from.
> 
> Anyway, all, please review.
> 
> ---
> 
> Ian Kent (4):
>       autofs4 - fix autofs4_expire_indirect() traversal
>       autofs4 - fix dentry leak in autofs4_expire_direct()
>       autofs4 - fix rootless multi-mount race
>       vfs - check non-mountpoint dentry might block in __follow_mount_rcu()
> 
> 
>  fs/autofs4/expire.c |   72 ++++++++++++++++++++++++++++++++++++++++-----------
>  fs/autofs4/root.c   |   20 +++-----------
>  fs/namei.c          |   24 ++++++++++++++---
>  3 files changed, 80 insertions(+), 36 deletions(-)
> 


