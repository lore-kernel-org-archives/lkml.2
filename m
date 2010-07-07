Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0GGQZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:25:12 -0400
Received: from [202.81.31.145] ([202.81.31.145]:56434 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0GGQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:25:10 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 04/11] vfs: Allow handle based open on symlinks
In-Reply-To: <20100707152303.GS11732@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1276621981-2774-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100707152303.GS11732@laptop>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 07 Jul 2010 21:54:52 +0530
Message-ID: <87d3uzfeej.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 01:23:03 +1000, Nick Piggin <npiggin@suse.de> wrote:
> On Tue, Jun 15, 2010 at 10:42:54PM +0530, Aneesh Kumar K.V wrote:
> > The patch update may_open to allow handle based open on symlinks.
> > The file handle based API use file descritor returned from open_by_handle_at
> > to do different file system operations. To find the link target name we
> > need to get a file descriptor on symlinks.
> 
> This is a pretty big change, isn't it?

Yes

> Have you looked through vfs to
> ensure this is actually OK? I was just looking at remount,ro code, for
> example, and it seems to assume only writable open files on ISREG
> files.

I verified that write and read returns an error on that descriptor. I
will look at rest of code to ensure the it doesn't break assumptions in
the rest of VFS.

> 
> Is this restricted to RDONLY? Really, it should be O_NONE...
> 
> 

we need the interface so that we can do fstat(lstat) and readlink using the
handle. If we are against the idea of allowing an fd on symlink, how about
adding stat_by_handle and readlink_by_handle syscall ? That way we can
drop "vfs: Support null pathname in readlink" patch 

-aneesh
