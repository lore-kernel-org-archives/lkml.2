Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0GCQhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:37:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45203 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0GCQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:37:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bQCkTJnerrWTlvBkJK9Lv8HFVF7Ns1BaxkQH4+hZvcxqrR/kyu+QzgKSzgc8nx3f0r
         olbN1b0CTjSSHzxgruXh5S3yrdMFGXtdqQMI8GDEz9rINfKI4k6o/JiwzwWcg0AJkBEi
         W5EJyol42HR4cjRnf7UQSwZs3k+Kz0NvPrmmw=
MIME-Version: 1.0
Date: Sat, 3 Jul 2010 12:37:43 -0400
Message-ID: <AANLkTimrfgftSTC9lqRmmTWIjXkHoZd4TIJGk0KVgqm3@mail.gmail.com>
Subject: DVD-RAM problems (low priority)
From: trouble daemon <troubledaemon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I am currently experiencing some problems with DVD-RAM media under
ubuntu lucid lynx, and I was wondering if you might recognize some of
the behaviour as being normal, or a bug.

What I do is insert a disk, then issue `mkudffs --media-type=dvdram
--utf8 /dev/sr0` and then `mount /media/cdrom0`. All seems to go well
and I get an entry that shows up as:

 /dev/sr0 on /media/cdrom0 type udf (rw,nosuid,nodev,utf8,user=dan)

At this point, I tried a simple copy of the linux git repository
(~850mb), but 3 hours later it is still copying. With other small test
writes, I also noticed that when I issue a umount, the command blocks
for maybe 10 seconds, then returns, yet the drive light appears to
continue to be writting for at least 5 minutes past the umount. At
that point it starts spiking a nice'd load or something, on one of the
cores of my system to 100% and stays there until I eject the disk. The
problem is that ejecting the disk seems to mess up the copy as well.
And even after I eject, the load stays at 100% on one core.

As for the drive, it is:

wodim: Overview of accessible drives (1 found) :
-------------------------------------------------------------------------
 0  dev='/dev/scd0'     rwrw-- : 'HL-DT-ST' 'DVDRAM GH22NS50'
-------------------------------------------------------------------------

Current kernel: Linux wks 2.6.32-23-generic #37-Ubuntu SMP Fri Jun 11
08:03:28 UTC 2010 x86_64 GNU/Linux

It seems that even after I umount, a program called
gvfs-gdu-volume-monitor starts going nuts writting to the disc and
pegging one of the cores, followed by udevd using 100% after an
eject+reinsert. Correct me if I am wrong, but absolutely nothing
should be writting to any device after a umount, no?

I should note that with very small tests of say 2-3mb, I can usually
get a successful write, but there still is the issue of the system still
writting in secret to the device after umount even then. Could this be
gvfs related?

Anyways, until I can track down exactly what might be interfering with
the writes, I would love to hear back on if I am just doing something
incorrectly. Please CC me email address, as I do not subscribe to
the LKML itself. Any help would be appreciated. Thanks!


PS - 	linux_udf@hpesjro.fc.hp.com as listed in the
Documentation/filesystems/udf.txt file, bounces


troubled
