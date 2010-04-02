Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab0DBATa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:19:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:38009 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0DBAT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:19:28 -0400
Date: Fri, 2 Apr 2010 02:19:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
Message-ID: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just hit this problem. Haven't bisected it yet, and going through 
shortlog doesn't ring any bell immediately, so I am sending this out in 
case it rings a bell for someone right away.

Calling 

	s2disk -r /dev/sdb4

suspends without any issues on 2.6.34-rc2, and resume is also fine. With 
2.6.34-rc3 I get

	s2disk: Could not use the resume device (try swapon -a). Reason: No such device

Relevant part of s2disk strace:

mount("none", "/proc/2449", "tmpfs", 0, NULL) = 0
stat64("/dev/sdb4", {st_mode=S_IFBLK|0660, st_rdev=makedev(259, 65536), ...}) = 0
chdir("/proc/2449")                     = 0
mknod("resume", S_IFBLK|0600, makedev(259, 65536)) = 0
open("resume", O_RDWR|O_LARGEFILE)      = 3
stat64("/dev/snapshot", {st_mode=S_IFCHR|0660, st_rdev=makedev(10, 231), ...}) = 0
open("/dev/snapshot", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, 0x400c330d, 0xbfdbcb04)        = -1 ENODEV (No such device)
ioctl(4, 0x4004330a, 0x10010300)        = -1 ENODEV (No such device)
write(2, "s2disk: Could not use the resume"..., 80s2disk: Could not use the resume device (try swapon -a). Reason: No such device

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
