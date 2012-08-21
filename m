Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2HUM3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:29:15 -0400
Received: from fieldses.org ([174.143.236.118]:46254 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab2HUM3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:29:12 -0400
Date: Tue, 21 Aug 2012 08:29:08 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120821122908.GE9483@fieldses.org>
References: <20120820183225.GB4911@fieldses.org>
 <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
 <20120821105424.GA7670@moon>
 <50336C51.60501@parallels.com>
 <20120821121155.GC9483@fieldses.org>
 <50337D87.90607@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50337D87.90607@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 04:22:31PM +0400, Pavel Emelyanov wrote:
> On 08/21/2012 04:11 PM, J. Bruce Fields wrote:
> > On Tue, Aug 21, 2012 at 03:09:05PM +0400, Pavel Emelyanov wrote:
> >> On 08/21/2012 02:54 PM, Cyrill Gorcunov wrote:
> >>> On Tue, Aug 21, 2012 at 02:49:47PM +0400, Pavel Emelyanov wrote:
> >>>>>>
> >>>>>> However, if you have some better ideas on what information about inode should be exported
> >>>>>> to the userspace please share.
> >>>>>>
> >>>>>
> >>>>> Why not use name_to_handle(fd,...) and open_by_handle(handle,..) ?
> >>>>
> >>>> Because we don't have an fd at hands by the time we need to know the handle.
> >>>
> >>> Yeah, this might be not clear from patchset itself but inotify marks carry
> >>> inodes inside kernel thus it's inodes what we can use when we fetch information
> >>> about targets and put it into fdinfo output.
> >>
> >> Al, Bruce, Aneesh,
> >>
> >> What if we calculate the handle at the time we do have struct path at hands (i.e.
> >> when we create the inotify) and store it on the inotify structure purely to be 
> >> shown later in proc. Would that be acceptable?
> > 
> > Was it the lack of a dentry that was really the problem?  I thought it
> > was just the fact that not all filesystems support filehandles.
> 
> Initial problem -- we don't know what is being watched by an inotify fd.
> 
> Having a dentry somewhere was the 1st attempt to solve this -- keep a path
> in inotify and show it when required. It doesn't work since holding a ref on
> path changes the behavior of watched inode (we cannot rename/unlink/remount
> it the same way as we could before patching the kernel).

OK.  So if you don't mind the fact that there are filesystems with
inotify support but not filehandle support, then I think generating a
filehandle early as you describe would work.  I guess it's a little more
memory per watched inode.

--b.
