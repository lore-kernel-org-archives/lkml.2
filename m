Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1C2Eia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:38:30 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47131 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1C2Ei3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:38:29 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 1/5] fs/9p: Fix revalidate to return correct value
In-Reply-To: <4D90F468.7020309@linux.vnet.ibm.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4D8D0009.8030806@linux.vnet.ibm.com> <4D90F468.7020309@linux.vnet.ibm.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 29 Mar 2011 10:08:18 +0530
Message-ID: <87zkoeczid.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 13:49:44 -0700, Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com> wrote:
> On 03/25/2011 01:50 PM, Venkateswararao Jujjuri wrote:
> > On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
> >> revalidate should return>  0 on success.
> >>
> >> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
> >
> > Reviewed-by: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
> >
> >> ---
> >>   fs/9p/vfs_dentry.c |    2 +-
> >>   1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
> >> index b6a3b9f..59c5ddc 100644
> >> --- a/fs/9p/vfs_dentry.c
> >> +++ b/fs/9p/vfs_dentry.c
> >> @@ -126,7 +126,7 @@ static int v9fs_lookup_revalidate(struct dentry 
> >> *dentry, struct nameidata *nd)
> >>               retval = v9fs_refresh_inode_dotl(fid, inode);
> >>           else
> >>               retval = v9fs_refresh_inode(fid, inode);
> >> -        if (retval<= 0)
> >> +        if (retval<  0)
> This change is causing tuxera rename test failure with acls enabled.
> 
> /root/pjd-fstest-20080816/tests/rename/10.t  (Wstat: 0 Tests: 188 Failed: 6)
>    Failed tests:  65, 71, 74, 77, 79-80
> The comment in namei says:
> "  If d_revalidate returned 0 attempt to invalidate  the dentry 
> otherwise d_revalidate is asking us
>   to return a fail status." I guess we need to return 0 in the case of 
> rename.
> Need more closer look at this patch.
> 

The failure is due to the VFS issue which I already reported. The
patch for that is here
http://article.gmane.org/gmane.linux.file-systems/51123

Previously we worked around that in 9p. But with the recent VFS changes
the work around applies no more, lookup_create fails on error in
lookup_hash and look_hash -> do_revalidate returns ENOENT.

-aneesh
