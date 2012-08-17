Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab2HQPjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:39:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2HQPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:39:03 -0400
Date: Fri, 17 Aug 2012 12:38:55 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>, Alex Elder <aelder@sgi.com>,
        Jan Kara <jack@suse.cz>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [v2.6.34-stable 013/165] xfs: Fix possible memory corruption in
 xfs_readlink
Message-ID: <20120817153855.GC4039@herton-Z68MA-D2H-B3>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
 <1345060109-9187-14-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345060109-9187-14-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:45:57PM -0400, Paul Gortmaker wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit b52a360b2aa1c59ba9970fb0f52bbb093fcc7a24 upstream.
> 
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Updated to address concerns raised by Ben Hutchings about the loose
> attention paid to 32- vs 64-bit values, and the lack of handling a
> potentially negative pathlen value:
>  - Changed type of "pathlen" to be xfs_fsize_t, to match that of
>    ip->i_d.di_size
>  - Added checking for a negative pathlen to the too-long pathlen
>    test, and generalized the message that gets reported in that case
>    to reflect the change
> As a result, if a negative pathlen were encountered, this function
> would return EFSCORRUPTED (and would fail an assertion for a debug
> build)--just as would a too-long pathlen.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> [PG: no xfs_alert in 2.6.34; use xfs_fs_cmn_err(CE_ALERT, ...) instead]
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
[...]

commit 9b025eb3a89e041bab6698e3858706be2385d692 ("xfs: Fix missing
xfs_iunlock() on error recovery path in xfs_readlink()") addresses a
regression with this change, something to consider for inclusion too.

-- 
[]'s
Herton
