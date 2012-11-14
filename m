Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2KNGqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:46:21 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51582 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2KNGqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:46:20 -0500
Date: Wed, 14 Nov 2012 10:46:15 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114064615.GB16685@moon>
References: <20121112101440.665694060@openvz.org>
 <20121112101845.839702715@openvz.org>
 <20121112165540.2ec39f50.akpm@linux-foundation.org>
 <20121113072057.GC6511@moon>
 <20121112234001.009b2ae3.akpm@linux-foundation.org>
 <20121113080032.GF6511@moon>
 <20121113143808.8d198bfe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113143808.8d198bfe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:38:08PM -0800, Andrew Morton wrote:
> On Tue, 13 Nov 2012 12:00:32 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > > Dumb question: do we really need inotify_inode_mark.fhandle at all? 
> > > What prevents us from assembling this info on demand when ->show_fdinfo() is
> > > called?
> > 
> > exportfs requires the dentry to be passed as an argument while inotify works
> > with inodes instead and at moment of show-fdinfo the target dentry might be
> > already deleted but inode yet present as far as I remember.
> 
> How can the c/r restore code reestablish the inode data if the dentry
> isn't there any more?

By "deleted" I meant deleted from dcache, thus when we call for
open_by_handle_at with fhandle, the kernel reconstruct the path
and we simply read the /proc/self/fd/ link, and then pass this
path to inotify_add_watch.
