Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2JREd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:33:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57700 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2JREd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:33:58 -0400
Date: Thu, 18 Oct 2012 05:33:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Li Zefan <lizefan@huawei.com>,
        Aristeu Rozanski <aris@redhat.com>, Tejun Heo <tj@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [patch for-3.7] fs, xattr: fix bug when removing a name not in
 xattr list
Message-ID: <20121018043333.GF2616@ZenIV.linux.org.uk>
References: <20121018024317.GA25407@localhost>
 <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1210172021320.32271@chino.kir.corp.google.com>
 <alpine.LSU.2.00.1210172052420.20979@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210172052420.20979@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 08:55:49PM -0700, Hugh Dickins wrote:
> On Wed, 17 Oct 2012, David Rientjes wrote:
> 
> > Commit 38f38657444d ("xattr: extract simple_xattr code from tmpfs") moved
> > some code from tmpfs but introduced a subtle bug along the way.
> > 
> > If the name passed to simple_xattr_remove() does not exist in the list of
> > xattrs, then it is possible to call kfree(new_xattr) when new_xattr is
> > actually initialized to itself on the stack via uninitialized_var().
> > 
> > This causes a BUG() since the memory was not allocated via the slab
> > allocator and was not bypassed through to the page allocator because it
> > was too large.
> > 
> > Initialize the local variable to NULL so the kfree() never takes place.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Acked-by: Hugh Dickins <hughd@google.com>
> 
> Thank you both: a fine example of the danger of uninitialized_var()!

Applied.
