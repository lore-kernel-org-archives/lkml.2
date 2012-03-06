Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2CFQM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:12:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2CFQM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:12:27 -0500
Date: Tue, 6 Mar 2012 16:12:24 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] overlayfs: apply device cgroup and security
 permissions to overlay files
Message-ID: <20120306161224.GE9978@shadowen.org>
References: <1329491451-14960-1-git-send-email-apw@canonical.com>
 <87pqcr9db4.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqcr9db4.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 06:18:23PM +0100, Miklos Szeredi wrote:
> Andy Whitcroft <apw@canonical.com> writes:
> 
> > When checking permissions on an overlayfs inode we do not take into
> > account either device cgroup restrictions nor security permissions.
> > This allows a user to mount an overlayfs layer over a restricted device
> > directory and by pass those permissions to open otherwise restricted
> > files.
> >
> > Use devcgroup_inode_permission() and security_inode_permission() against
> > the underlying inodes when calculating ovl_permission().
> 
> Andy,
> 
> Thanks for the patch.
> 
> __devcgroup_inode_permission() and security_inode_permission() are not
> exported to modules, so this will not work if overlayfs is a module.
> 
> We could export those but I think a better solution is to split out the
> part of inode_permission() that doesn't check for a read-only fs and
> export that.

Yeah that makes much more sense.  I got caught out by some exports
required for aufs3 which was also applied in my test environment.

How about the following pair of patches?

-apw
