Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1EXNAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:00:18 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41907 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab1EXNAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:00:17 -0400
Date: Tue, 24 May 2011 09:00:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: once again, tracking down misconfigured CONFIG variables
Message-ID: <alpine.DEB.2.00.1105240851080.21813@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  now that we're into another merge window, i'll try to find time this
week to run my kernel scanning/cleanup scripts to find discrepancies
in the source related to unused/misreferenced Kconfig variables and
similar things.

  the top level of the output from the last time i did this is here:

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

so you can follow any of those links to see the more specific output,
much of which i'm guessing is still valid.

  you're also welcome to run the scripts yourself, they're here (and
probably need a bit of tweaking these days):

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

you can run these scripts with an argument of the specific source
directory that interests you, so here's an example based on a recent
"git pull", showing what i call "badrefs" for CONFIG variables:

$ ../s/find_badref_configs.sh kernel
>>>>> DEBUG_SHIRQ_FIXME
kernel/irq/manage.c:1329:#ifdef CONFIG_DEBUG_SHIRQ_FIXME
>>>>> HIGHRES_TIMERS
kernel/hrtimer.c:751:#ifdef CONFIG_HIGHRES_TIMERS
>>>>> KDB_CONTINUE_CATASTROPHIC
kernel/debug/kdb/kdb_main.c:70:#ifdef CONFIG_KDB_CONTINUE_CATASTROPHIC
kernel/debug/kdb/kdb_main.c:72:	CONFIG_KDB_CONTINUE_CATASTROPHIC;
$

  in other words, under the top-level "kernel" directory, there are
preprocessor tests for CONFIG variables that don't appear to be
defined anywhere and are therefore useless.  same thing for the entire
"fs" directory:

$ ../s/find_badref_configs.sh fs
>>>>> BEFS_RW
fs/befs/linuxvfs.c:786:#ifndef CONFIG_BEFS_RW
fs/befs/linuxvfs.c:792:#endif				/* CONFIG_BEFS_RW */
>>>>> CIFS_DNOTIFY_EXPERIMENTAL
fs/cifs/cifsglob.h:784:#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
fs/cifs/cifsfs.c:990:#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
fs/cifs/cifsproto.h:392:#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
fs/cifs/cifssmb.c:5735:#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* BB unused temporarily */
>>>>> CIFS_SYMLINK_EXPERIMENTAL
fs/cifs/cifsproto.h:311:#ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
fs/cifs/cifssmb.c:2524:#ifdef CONFIG_CIFS_SYMLINK_EXPERIMENTAL
fs/cifs/cifssmb.c:2636:#endif /* CIFS_SYMLINK_EXPERIMENTAL */ /* BB temporarily unused */
>>>>> KDB_MODULES
fs/xfs/linux-2.6/xfs_buf.h:342:#ifdef CONFIG_KDB_MODULES
fs/xfs/linux-2.6/xfs_buf.c:1893:#ifdef CONFIG_KDB_MODULES
>>>>> NILFS_POSIX_ACL
fs/nilfs2/nilfs.h:189:#ifdef CONFIG_NILFS_POSIX_ACL
>>>>> NILFS_XATTR
fs/nilfs2/nilfs.h:49:#ifdef CONFIG_NILFS_XATTR
fs/nilfs2/super.c:1376:#ifdef CONFIG_NILFS_XATTR
$

  you get the idea.  and if people are talking about an eventual 3.0,
part of that process should be a concerted effort to get rid of all
this historical cruft that's been hanging around, some of it for a
long, long time.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================


