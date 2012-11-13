Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2KMWiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:38:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2KMWiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:38:09 -0500
Date: Tue, 13 Nov 2012 14:38:08 -0800
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
Message-Id: <20121113143808.8d198bfe.akpm@linux-foundation.org>
In-Reply-To: <20121113080032.GF6511@moon>
References: <20121112101440.665694060@openvz.org>
	<20121112101845.839702715@openvz.org>
	<20121112165540.2ec39f50.akpm@linux-foundation.org>
	<20121113072057.GC6511@moon>
	<20121112234001.009b2ae3.akpm@linux-foundation.org>
	<20121113080032.GF6511@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 12:00:32 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> > Dumb question: do we really need inotify_inode_mark.fhandle at all? 
> > What prevents us from assembling this info on demand when ->show_fdinfo() is
> > called?
> 
> exportfs requires the dentry to be passed as an argument while inotify works
> with inodes instead and at moment of show-fdinfo the target dentry might be
> already deleted but inode yet present as far as I remember.

How can the c/r restore code reestablish the inode data if the dentry
isn't there any more?
