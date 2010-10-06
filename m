Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0JFDns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:43:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51396 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551Ab0JFDnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:43:46 -0400
Date: Wed, 6 Oct 2010 14:43:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the bkl-config tree with the
 staging-next tree
Message-Id: <20101006144342.6da4a30b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-config tree got a conflict in
fs/compat_ioctl.c between commit 2116b7a473bf1c8d26998b477c294e7fe294921f
("smbfs: move to drivers/staging") from the staging-next tree and commit
b9abbb0214fbdbdf36fc0edebd4b1adb7ddb3a12 ("fix rawctl compat ioctls
breakage on amd64 and itanic") from the bkl-config tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/compat_ioctl.c
index 34cf03c,d0ad09d..0000000
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@@ -1242,9 -1199,8 +1179,6 @@@ COMPATIBLE_IOCTL(SOUND_MIXER_PRIVATE5
  COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
  COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
  COMPATIBLE_IOCTL(OSS_GETVERSION)
- /* Raw devices */
- COMPATIBLE_IOCTL(RAW_SETBIND)
- COMPATIBLE_IOCTL(RAW_GETBIND)
 -/* SMB ioctls which do not need any translations */
 -COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
  /* Watchdog */
  COMPATIBLE_IOCTL(WDIOC_GETSUPPORT)
  COMPATIBLE_IOCTL(WDIOC_GETSTATUS)
@@@ -1501,11 -1457,11 +1435,7 @@@ static long do_ioctl_trans(int fd, unsi
  	case MTIOCGET32:
  	case MTIOCPOS32:
  		return mt_ioctl_trans(fd, cmd, argp);
- 	/* Raw devices */
- 	case RAW_SETBIND:
- 	case RAW_GETBIND:
- 		return raw_ioctl(fd, cmd, argp);
  #endif
 -	/* One SMB ioctl needs translations. */
 -#define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 -	case SMB_IOC_GETMOUNTUID_32:
 -		return do_smb_getmountuid(fd, cmd, argp);
  	/* Serial */
  	case TIOCGSERIAL:
  	case TIOCSSERIAL:
