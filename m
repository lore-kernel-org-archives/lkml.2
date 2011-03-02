Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1CBLp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:45:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab1CBLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:45:28 -0500
Date: Wed, 2 Mar 2011 12:45:17 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: t.artem@mailcity.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Roman Zippel <zippel@linux-m68k.org>
Subject: MS_SILENT vs. vfat and hfs
Message-ID: <20110302114517.GA496@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 The mount(8) command uses "quiet" mount option as a synonym to the
 MS_SILENT mount flag (since util-linux 2.7, Aug 1997).

 It means than on systems where is properly defined the MS_SILENT
 mount flags in headers is the "quiet" mount option always translated
 to the MS_SILENT mount flags and "quiet" string is never send to FS
 drivers.

   $ strace -e mount mount -o quiet /dev/sdb1 /mnt/test
   mount("/dev/sdb1", "/mnt/test", "vfat", MS_MGC_VAL|MS_SILENT, NULL) = 0
                                                      ^^^^^^^^^

 Unfortunately, 
 
   $ grep -r \"quiet\" *

   fat/inode.c:    {Opt_quiet, "quiet"},
   hfs/super.c:    { opt_quiet, "quiet" },

 vfat and hfs drivers use "quiet" as a mount option. That's bug.

 There should not be a collision between mount(8) mount options and
 filesystem specific mount options.

 My suggestion is to fix the fat and hfs code to use something other
 than "quiet" (shutup, noisless, ...). I think you don't have to care
 about backward compatibility, because it's probably broken for years.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
