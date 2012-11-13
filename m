Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2KMHkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:40:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2KMHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:40:05 -0500
Date: Mon, 12 Nov 2012 23:40:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-Id: <20121112234001.009b2ae3.akpm@linux-foundation.org>
In-Reply-To: <20121113072057.GC6511@moon>
References: <20121112101440.665694060@openvz.org>
	<20121112101845.839702715@openvz.org>
	<20121112165540.2ec39f50.akpm@linux-foundation.org>
	<20121113072057.GC6511@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 11:20:57 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> > >  struct inotify_inode_mark {
> > >  	struct fsnotify_mark fsn_mark;
> > >  	int wd;
> > > +#ifdef INOTIFY_USE_FHANDLE
> > > +	__u8 fhandle[sizeof(struct file_handle) + MAX_HANDLE_SZ];
> > > +#endif
> > >  };
> > 
> > Whoa.  This adds 128+8 bytes to the inotify_inode_mark.  That's a lot of
> > bloat, and there can be a lot of inotify_inode_mark's in the system?
> 
> Yes, that's why it's not turned on by default, only if is c/r turned on.
> iirc I've been said that usually only about 40 bytes is used (in the tests
> I met only 8 bytes). Letme re-check all things.

The question is, how many `struct inotify_inode_mark's are instantiated
system-wide?  Could be millions?

Dumb question: do we really need inotify_inode_mark.fhandle at all? 
What prevents us from assembling this info on demand when ->show_fdinfo() is
called?


