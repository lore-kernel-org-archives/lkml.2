Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab1FQWGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:06:16 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37215 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1FQWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:06:14 -0400
Date: Fri, 17 Jun 2011 18:06:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should CONFIG_TMPFS_POSIX_ACL be so easily deselectable?
Message-ID: <alpine.DEB.2.02.1106171756470.4381@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
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


  long story short:  in updating to a slightly newer hand-rolled
kernel (2.6.39-rc7 -> 3.0.0-rc3) on my ubuntu system, i somehow (no
idea how) managed to deselect CONFIG_TMPFS_POSIX_ACL without realizing
it.  the consequences of this were that sound suddenly disappeared
under the new kernel, for a fairly obvious reason -- ALSA needs ACLs
under /dev to give R/W access to the user to the device files under
/dev/snd/.

  as i said, i have no idea how i managed to do this but i eventually
tracked it down, re-selected that option, rebuilt and i have sound
again.  but i noticed that in fs/Kconfig, that option is independently
selectable from TMPFS, so it's (as i learned) deviously easy to
deselect, with annoying consequences.

  more to the point, given the apparent necessity of ACLs under /dev
for proper sound operation, the help info for that option seems a bit
misleading:

config TMPFS_POSIX_ACL
        bool "Tmpfs POSIX Access Control Lists"
        depends on TMPFS
        select TMPFS_XATTR
        select GENERIC_ACL
        help
          ... snip ...
          If you don't know what Access Control Lists are, say N.

  yeah, i think that help line might not want to dismiss tmpfs ACLs
quite so quickly.  thoughts?

rday

p.s.  i do notice a fairly recent change to that config file related
to this:

commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
Author: Eric Paris <eparis@redhat.com>
Date:   Wed May 25 19:49:18 2011 -0700

    tmpfs: fix XATTR N overriding POSIX_ACL Y

    Choosing TMPFS_XATTR default N was switching off TMPFS_POSIX_ACL,
    even if it had been Y in oldconfig; and Linus reports that PulseAudio
    goes subtly wrong unless it can use ACLs on /dev/shm.

    Make TMPFS_POSIX_ACL select TMPFS_XATTR (and depend upon TMPFS),
    and move the TMPFS_POSIX_ACL entry before the TMPFS_XATTR entry,
    to avoid asking unnecessary questions then ignoring their answers.


-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
