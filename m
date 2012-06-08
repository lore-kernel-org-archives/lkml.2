Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131Ab2FHWkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:40:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FHWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:40:39 -0400
Date: Fri, 8 Jun 2012 15:40:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Message-Id: <20120608154037.e3069eab.akpm@linux-foundation.org>
In-Reply-To: <20120608223624.GU30000@ZenIV.linux.org.uk>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20120608150253.e42464a6.akpm@linux-foundation.org>
	<20120608221446.GA18250@otc-wbsnb-06>
	<20120608152550.258d6a30.akpm@linux-foundation.org>
	<20120608222734.GT30000@ZenIV.linux.org.uk>
	<20120608153120.b722d7c3.akpm@linux-foundation.org>
	<20120608223624.GU30000@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012 23:36:24 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Jun 08, 2012 at 03:31:20PM -0700, Andrew Morton wrote:
> > On Fri, 8 Jun 2012 23:27:34 +0100
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Fri, Jun 08, 2012 at 03:25:50PM -0700, Andrew Morton wrote:
> > > 
> > > > A neater implementation might be to add a kmem_cache* argument to
> > > > unregister_filesystem().  If that is non-NULL, unregister_filesystem()
> > > > does the rcu_barrier() and destroys the cache.  That way we get to
> > > > delete (rather than add) a bunch of code from all filesystems and new
> > > > and out-of-tree filesystems cannot forget to perform the rcu_barrier().
> > > 
> > > There's often enough more than one cache, so that one is no-go.
> > 
> > kmem_cache** ;)
> > 
> > Which filesystems have multiple inode caches?
> 
> inodes are not the only things that get caches of their own...

Yes, but other random non-inode caches do not get rcu requirements
secretly forced upon them by the vfs so don't need rcu_barrier() prior
to their destruction?

> BTW, Kirill, would you mind not cross-posting to that many lists ever again?

I dunno, I like all those little messages - it makes me feel important.
