Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0DBQx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:53:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0DBQxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:53:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.34-rc3 doesn't suspend to disk (-rc2 did)
Date: Fri, 2 Apr 2010 18:56:42 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1004020215100.8345@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004021856.42092.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 April 2010, Jiri Kosina wrote:
> Hi,

Hi,

> I have just hit this problem. Haven't bisected it yet, and going through 
> shortlog doesn't ring any bell immediately, so I am sending this out in 
> case it rings a bell for someone right away.

No, and it works for me on a couple of systems.

> Calling 
> 
> 	s2disk -r /dev/sdb4
> 
> suspends without any issues on 2.6.34-rc2, and resume is also fine. With 
> 2.6.34-rc3 I get
> 
> 	s2disk: Could not use the resume device (try swapon -a). Reason: No such device
> 
> Relevant part of s2disk strace:
> 
> mount("none", "/proc/2449", "tmpfs", 0, NULL) = 0
> stat64("/dev/sdb4", {st_mode=S_IFBLK|0660, st_rdev=makedev(259, 65536), ...}) = 0
> chdir("/proc/2449")                     = 0
> mknod("resume", S_IFBLK|0600, makedev(259, 65536)) = 0
> open("resume", O_RDWR|O_LARGEFILE)      = 3
> stat64("/dev/snapshot", {st_mode=S_IFCHR|0660, st_rdev=makedev(10, 231), ...}) = 0
> open("/dev/snapshot", O_RDONLY|O_LARGEFILE) = 4
> ioctl(4, 0x400c330d, 0xbfdbcb04)        = -1 ENODEV (No such device)
> ioctl(4, 0x4004330a, 0x10010300)        = -1 ENODEV (No such device)
> write(2, "s2disk: Could not use the resume"..., 80s2disk: Could not use the resume device (try swapon -a). Reason: No such device

It seems that swap_type_of() returns error code for your swap device.

I'd put a couple of debug printks in there to see what happens.

Rafael
