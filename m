Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2IMV0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:26:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43924 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2IMV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:26:22 -0400
MIME-Version: 1.0
From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Thu, 13 Sep 2012 23:26:01 +0200
Message-ID: <CAAcnjCR2c0qVCJEwH91ajnZ_vKHNFiUv8EUUU7x9ZTD+L5nOBg@mail.gmail.com>
Subject: Linux hfsplus corrupts chflags bits?
To: fs_hfs@kernel-bugs.osdl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Matthew Garrett <mjg@redhat.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please CC me on replies as I'm not subscribed.]

The Linux hfsplus implementation seems to repeatedly corrupt
hfsplus_perm->rootflags; when the same filesystem is read on Mac OS X,
this changes the attribs touched by chflags and makes a random
selection of files "locked" and thus untouchable. This happened for me
on Ubuntu 12.04 "Precise Pangolin", based on a 3.2.0 kernel, reports
appear from various other versions and the source doesn't seem heavily
changed.

I've had experience of this, shared by other users on this
superuser.com discussion:
http://superuser.com/a/457494/46794

Given that hfsplus isn't even mentioned in MAINTAINERS, I've used
./scripts/get_maintainer.pl to select recipients.

To convince you that the flags are in fact set randomly, here's a
listing of the backup of my home created through rsync on Linux (which
supposedly isn't even aware of these flags). Notice: none of these
flags are supposed to be set.

# 'ls' -ld -O /Volumes/HFS+Backup/Users/pgiarrusso/*
drwx------   31 pgiarrusso  staff  uchg,nodump,opaque         1054 Aug
13 02:00 /Volumes/HFS+Backup/Users/pgiarrusso/Desktop
drwx------   36 pgiarrusso  staff  nodump                     1224 Jul
22 16:04 /Volumes/HFS+Backup/Users/pgiarrusso/Documents
drwx------  108 pgiarrusso  staff  uappnd                     3672 Aug
13 11:43 /Volumes/HFS+Backup/Users/pgiarrusso/Downloads
drwx------   13 pgiarrusso  staff  uappnd,uchg,opaque          442 Jul
22 05:04 /Volumes/HFS+Backup/Users/pgiarrusso/Dropbox
drwx------   53 pgiarrusso  staff  -                          1802 Aug
12 00:58 /Volumes/HFS+Backup/Users/pgiarrusso/Library
drwx------   11 pgiarrusso  staff  uchg,nodump,opaque          374 Jul
22 17:25 /Volumes/HFS+Backup/Users/pgiarrusso/Movies
drwx------   13 pgiarrusso  staff  uappnd,uchg,nodump          442 Jun
10 12:05 /Volumes/HFS+Backup/Users/pgiarrusso/Music
drwx------   15 pgiarrusso  staff  uappnd,nodump,opaque        510 Jun
10 12:05 /Volumes/HFS+Backup/Users/pgiarrusso/Pictures
drwxr-x---   11 pgiarrusso  staff  opaque                      374 Jul
 6 15:33 /Volumes/HFS+Backup/Users/pgiarrusso/Public
drwxr-xr-x   34 pgiarrusso  staff  uappnd,uchg,opaque         1156 May
27 12:39 /Volumes/HFS+Backup/Users/pgiarrusso/Sites
drwxr-xr-x    2 pgiarrusso  staff  uappnd,nodump,opaque         68 Jun
10 21:43 /Volumes/HFS+Backup/Users/pgiarrusso/VirtualBox VMs
-rwxr-xr-x    1 pgiarrusso  staff  uappnd,nodump,opaque       1703 Feb
19  2012 /Volumes/HFS+Backup/Users/pgiarrusso/bash-prompt.sh
drwxr-xr-x   22 pgiarrusso  staff  -                           748 Aug
10 19:47 /Volumes/HFS+Backup/Users/pgiarrusso/bin
lrwxrwxrwx    1 pgiarrusso  staff  nodump,opaque                37 Sep
27  2011 /Volumes/HFS+Backup/Users/pgiarrusso/default.sfx ->
/Users/pgiarrusso/opt/rar/default.sfx
-rw-r--r--    1 pgiarrusso  staff  uappnd,uchg          1375563169 Aug
 2 18:52 /Volumes/HFS+Backup/Users/pgiarrusso/heapdump-1343925310626.hprof
drwxr-xr-x   22 pgiarrusso  staff  uappnd,nodump               748 Aug
 1 22:15 /Volumes/HFS+Backup/Users/pgiarrusso/opt
drwxr-xr-x    7 pgiarrusso  staff  uappnd                      238 Apr
19 20:00 /Volumes/HFS+Backup/Users/pgiarrusso/share
drwxr-xr-x   35 pgiarrusso  staff  nodump,opaque              1190 Aug
10 00:06 /Volumes/HFS+Backup/Users/pgiarrusso/tmp

Cheers,
-- 
Paolo 'Blaisorblade' Giarrusso - Ph.D. Student
http://www.informatik.uni-marburg.de/~pgiarrusso/
