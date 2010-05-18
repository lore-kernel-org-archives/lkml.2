Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0ERGnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:43:43 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:34861 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755285Ab0ERGnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:43:41 -0400
Date: Tue, 18 May 2010 16:43:36 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
Message-ID: <20100518064336.GE2150@dastard>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <7252.1274150030@jrobl>
 <87fx1ppy21.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fx1ppy21.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 11:10:38AM +0530, Aneesh Kumar K. V wrote:
> On Tue, 18 May 2010 11:33:50 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> > 
> > "Aneesh Kumar K.V":
> > > This patch add a new superblock operations get_fsid that returns the
> > > UUID mapping for the file system. The UUID returned is used to
> > > identify the file system apart of file_handle
> > 
> > I am afraid get_fsid in s_op may conflict with "fsid=" option in /etc/exports.
> > Generally all FSs have UUID or device number and they can return "fsid"
> > correctly. But some of them may not have such id, or users may assign
> > different fsid for them.
> > Is "fsid=" value passed to superblock and can FS return it? Otherwise
> > they cannot implement ->get_fsid().
> 
> The file_handle I mentioned above is the file handle returned by
> sys_name_to_handle_at syscall. NFS kernel server won't be using the
> interface.
> 
> If file system doesn't support a unique identifier then they can leave
> ->get_fsid callback NULL. The UUID part of the file_handle will be zero
> filled.

If it is returning a UUID, then perhaps the call should be
->get_uuid to avoid any confusion with existing uses of "fsid".

Alternatively, why do we even need a method for this? Why not just put a
struct uuid into the struct super_block and have filesystems fill it
out inside their fill_super callback to get_sb()? If it is not
filled out, then it is zero, and the code that puts it into the file
handle can just do an unconditional copy at that point...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
