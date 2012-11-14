Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098Ab2KNKNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:13:51 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:35880 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2KNKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:13:49 -0500
Date: Wed, 14 Nov 2012 14:13:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114101344.GG16685@moon>
References: <20121112101440.665694060@openvz.org>
 <20121112101845.839702715@openvz.org>
 <20121112165540.2ec39f50.akpm@linux-foundation.org>
 <20121113072057.GC6511@moon>
 <20121112234001.009b2ae3.akpm@linux-foundation.org>
 <20121113080032.GF6511@moon>
 <20121113143808.8d198bfe.akpm@linux-foundation.org>
 <20121114064615.GB16685@moon>
 <50A36E2A.8040302@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A36E2A.8040302@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 02:10:50PM +0400, Pavel Emelyanov wrote:
> >>
> >> How can the c/r restore code reestablish the inode data if the dentry
> >> isn't there any more?
> > 
> > By "deleted" I meant deleted from dcache, thus when we call for
> > open_by_handle_at with fhandle, the kernel reconstruct the path
> > and we simply read the /proc/self/fd/ link, and then pass this
> > path to inotify_add_watch.
> 
> No we don't do readlink as the path we'd see would be empty. Instead after
> we called the open_by_handle_at, we pass the "/proc/self/fd/<fd>" _path_ itself
> to inotify_add_watch. The path resolution code follows the link properly and
> adds the target inode into the watch list.

Yeah, sorry for confusion.
