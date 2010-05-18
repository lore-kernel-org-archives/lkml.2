Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0ERKRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:17:24 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44687 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab0ERKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:17:18 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <20100518064336.GE2150@dastard>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <20100518064336.GE2150@dastard>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 18 May 2010 15:47:08 +0530
Message-ID: <877hn1pl97.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 16:43:36 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, May 18, 2010 at 11:10:38AM +0530, Aneesh Kumar K. V wrote:
> > On Tue, 18 May 2010 11:33:50 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> > > 
> > > "Aneesh Kumar K.V":
> > > > This patch add a new superblock operations get_fsid that returns the
> > > > UUID mapping for the file system. The UUID returned is used to
> > > > identify the file system apart of file_handle
> > > 
> > > I am afraid get_fsid in s_op may conflict with "fsid=" option in /etc/exports.
> > > Generally all FSs have UUID or device number and they can return "fsid"
> > > correctly. But some of them may not have such id, or users may assign
> > > different fsid for them.
> > > Is "fsid=" value passed to superblock and can FS return it? Otherwise
> > > they cannot implement ->get_fsid().
> > 
> > The file_handle I mentioned above is the file handle returned by
> > sys_name_to_handle_at syscall. NFS kernel server won't be using the
> > interface.
> > 
> > If file system doesn't support a unique identifier then they can leave
> > ->get_fsid callback NULL. The UUID part of the file_handle will be zero
> > filled.
> 
> If it is returning a UUID, then perhaps the call should be
> ->get_uuid to avoid any confusion with existing uses of "fsid".
> 
> Alternatively, why do we even need a method for this? Why not just put a
> struct uuid into the struct super_block and have filesystems fill it
> out inside their fill_super callback to get_sb()? If it is not
> filled out, then it is zero, and the code that puts it into the file
> handle can just do an unconditional copy at that point...
> 

Now that we are not doing UUID based vfsmount lookup this make
sense. Will update in the next iteration with UUID to be part of
super_block.

-aneesh
