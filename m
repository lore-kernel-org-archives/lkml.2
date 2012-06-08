Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2FHWg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:36:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56101 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2FHWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:36:26 -0400
Date: Fri, 8 Jun 2012 23:36:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Message-ID: <20120608223624.GU30000@ZenIV.linux.org.uk>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120608150253.e42464a6.akpm@linux-foundation.org>
 <20120608221446.GA18250@otc-wbsnb-06>
 <20120608152550.258d6a30.akpm@linux-foundation.org>
 <20120608222734.GT30000@ZenIV.linux.org.uk>
 <20120608153120.b722d7c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608153120.b722d7c3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:31:20PM -0700, Andrew Morton wrote:
> On Fri, 8 Jun 2012 23:27:34 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Fri, Jun 08, 2012 at 03:25:50PM -0700, Andrew Morton wrote:
> > 
> > > A neater implementation might be to add a kmem_cache* argument to
> > > unregister_filesystem().  If that is non-NULL, unregister_filesystem()
> > > does the rcu_barrier() and destroys the cache.  That way we get to
> > > delete (rather than add) a bunch of code from all filesystems and new
> > > and out-of-tree filesystems cannot forget to perform the rcu_barrier().
> > 
> > There's often enough more than one cache, so that one is no-go.
> 
> kmem_cache** ;)
> 
> Which filesystems have multiple inode caches?

inodes are not the only things that get caches of their own...

BTW, Kirill, would you mind not cross-posting to that many lists ever again?
