Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1CKEou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 23:44:50 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48152 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1CKEos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 23:44:48 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org, arnd@arndb.de,
        mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
In-Reply-To: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <20110303072223.GA28133@elie> <87bp1sziqn.fsf@linux.vnet.ibm.com> <Pine.LNX.4.64.1103071515070.11152@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Fri, 11 Mar 2011 10:14:35 +0530
Message-ID: <87zkp21d1o.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 11:31:30 -0800 (PST), Sage Weil <sage@newdream.net> wrote:
> It is frequently useful to sync a single file system, instead of all
> mounted file systems via sync(2):
> 
>  - On machines with many mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).
>  - Some applications write lots of data to the file system and then
>    want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.
> 
> There are currently two ways (that I know of) to sync a single super_block:
> 
>  - BLKFLSBUF ioctl on the block device: That also invalidates the bdev
>    mapping, which isn't usually desirable, and doesn't work for non-block
>    file systems.
>  - 'mount -o remount,rw' will call sync_filesystem as an artifact of the
>    current implemention.  Relying on this little-known side effect for
>    something like data safety sounds foolish.
> 
> Both of these approaches require root privileges, which some applications
> do not have (nor should they need?) given that sync(2) is an unprivileged
> operation.
> 
> This patch introduces a new system call syncfs(2) that takes an fd and
> syncs only the file system it references.  Maybe someday we can
> 
>  $ sync /some/path
> 
> and not get
> 
>  sync: ignoring all arguments
> 
> The syscall is motivated by comments by Al and Christoph at the last LSF.
> syncfs(2) seems like an appropriate name given statfs(2).
> 
> A similar ioctl was also proposed a while back, see
> 	http://marc.info/?l=linux-fsdevel&m=127970513829285&w=2
> 
> Signed-off-by: Sage Weil <sage@newdream.net>

Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

