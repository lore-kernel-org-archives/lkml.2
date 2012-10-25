Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab2JYMVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:21:41 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:60788 "EHLO ofcsgdbm.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab2JYMVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:21:39 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2012 08:21:39 EDT
Date: Thu, 25 Oct 2012 12:13:40 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Enabling hardlink restrictions to the Linux VFS in 3.6 by default
Message-ID: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of linux 3.6 hardlink restrictions to the Linux VFS have been enabled
by default. This breaks the application AFD [1] of which I am the author.
Internally it uses hardlink to distribute files. The reason for hardlinks
is that AFD can distribute one file to many destinations and for each
distributing process it creates a directory with hardlinks to the original
file. That way AFD itself never needs to copy the content of a file. Another
nice feature about hardlinks was that there is no need to have any logic in
the code needing AFD to know where the original file was, each distributing
process could delete its hardlink and the last one would delete the real
file. This way AFD could distribute files at rates of more then 20000 files
per second (in benchmarks). This has worked from the first linux kernel
up to 3.5.7 and with solaris, hpux, aix, ftx, irix. As of 3.6 this does
not work for files where AFD does not have write permissions. It was always
sufficient to just have read permission on a file it wants to distribute.

The fix for the "at" daemon [2] mentioned in the commitdiff [3] cannot
be used for AFD since it is not run with root privileges. Is there any
other way I can "fix" my application? I currently can see no other way
then doing it via: echo 0 > /proc/sys/fs/protected_hardlinks

Why is such a fundamentally change to the linux kernel activated by default?
Would it not be better if it is the other way around, that the system
administrator or distributions enable this?

Regards,
Holger

PS: Please CC me as I am not on the list.


[1] http://www.dwd.de/AFD
[2] http://anonscm.debian.org/gitweb/?p=collab-maint/at.git;a=commitdiff;h=f4114656c3a6c6f6070e315ffdf940a49eda3279
[3] https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=800179c9b8a1e796e441674776d11cd4c05d61d7
