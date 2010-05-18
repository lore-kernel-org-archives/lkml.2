Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0ERFkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:40:49 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34064 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0ERFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:40:48 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <7252.1274150030@jrobl>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 18 May 2010 11:10:38 +0530
Message-ID: <87fx1ppy21.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010 11:33:50 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> 
> "Aneesh Kumar K.V":
> > This patch add a new superblock operations get_fsid that returns the
> > UUID mapping for the file system. The UUID returned is used to
> > identify the file system apart of file_handle
> 
> I am afraid get_fsid in s_op may conflict with "fsid=" option in /etc/exports.
> Generally all FSs have UUID or device number and they can return "fsid"
> correctly. But some of them may not have such id, or users may assign
> different fsid for them.
> Is "fsid=" value passed to superblock and can FS return it? Otherwise
> they cannot implement ->get_fsid().

The file_handle I mentioned above is the file handle returned by
sys_name_to_handle_at syscall. NFS kernel server won't be using the
interface.

If file system doesn't support a unique identifier then they can leave
->get_fsid callback NULL. The UUID part of the file_handle will be zero
filled. For a NFS userspace server, the server can update handle.fsid with
what ever value is configured for fsid. The only requirement is later
when provided with the same handle NFS server should be able to map the
handle.fsid to a mountdirfd which can be used with sys_open_by_handle_at.

-aneesh
