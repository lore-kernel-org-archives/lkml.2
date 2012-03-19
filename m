Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2CSISC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:18:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36993 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2CSISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:18:00 -0400
Date: Mon, 19 Mar 2012 11:17:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
Message-ID: <20120319081753.GA3333@p183.telecom.by>
References: <20120313005855.GA24639@redhat.com>
 <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
 <20120318192755.GB6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120318192755.GB6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 07:27:55PM +0000, Al Viro wrote:
> On Sun, Mar 18, 2012 at 12:02:04PM -0700, Linus Torvalds wrote:
> Incidentally, I wonder if we want the whole thing in fs/proc; the argument
> against splitoff to a separate fs used to be "that would break userland
> setups - can't ask people to update /etc/fstab or init scripts to mount
> that thing on /proc/sys".  Fair enough, but... what's to stop us from slapping
> ->d_automount() on /proc/sys like that:
> 	struct vfsmount *mnt = vfs_kern_mount(&sysctlfs_type, 0, "sysctl", 0);
> 	if (!IS_ERR(mnt))
> 		mntget(mnt);
> 	return mnt;
> and we are all set.  IOW, now that ->d_automount() stuff is there, we can
> do that easily without any userland breakage.  Comments?

IIRC, fstab argument was the only one.
