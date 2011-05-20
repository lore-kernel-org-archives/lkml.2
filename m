Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1ETDDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:03:22 -0400
Received: from hades.mikemestnik.net ([184.106.158.151]:46083 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab1ETDDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:03:21 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 23:03:21 EDT
Message-ID: <4DD5D7D3.2050801@mikemestnik.net>
Date: Thu, 19 May 2011 21:54:11 -0500
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fwd: Re: World writable pid and lock files.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I'd just like to ask about /proc/$$/exe and it's potential use for pid
to application mapping for daemon stop/restart scripts.  It's also a
little odd to think that it might not be suitable for debuggers, for
example "gdb /proc/1234/exe 1234".  I believe that it currently
functions for daemon stop/restart scripts because the script matches the
device/inode numbers against the path it would execute.  As long as
there is a file in this location, any file, the test would pass. 
However as my test demonstrates if there was no file at that location
the test would fail.

It works, but it's also broken...  or maybe it isn't?  What do I know. 
I received no response to my posting to debian-security and I believe
this merits some discussion.  I understand that this has vary little to
do with the Linux kernel and is instead a distribution issue, however
I'd like clarification of the purpose and correct usage of /proc/$$/exe.

-------- Original Message --------
Subject: 	Re: World writable pid and lock files.
Resent-Date: 	Sun, 15 May 2011 18:00:25 +0000 (UTC)
Resent-From: 	debian-security@lists.debian.org
Date: 	Sun, 15 May 2011 12:44:11 -0500
From: 	Mike Mestnik <cheako@mikemestnik.net>
To: 	Henrique de Moraes Holschuh <hmh@debian.org>,
debian-security@lists.debian.org



Henrique de Moraes Holschuh wrote:
> You know, it would help if you actually read what you replied to.
>
>   
start-stop-daemon(8) says
/proc/pid/exe is used.  On my system that is a symbolic link.  What I 
wold do if I was to write start-stop-daemon is read the link and match 
that value with the name passed to --exec.  This would have nothing to do
with inode numbers.  However start-stop-daemon might look at the inode 
number of the dereferenced link and match that to the inode number of 
the name passed to --exec.  This should also match, though there is a 
race condition here.  I'm a bit confused as /proc/pid/exe should be 
usable for debuggers like gdb.

cheako@www:~$ cp /bin/bash .
cheako@www:~$ ./bash
cheako@www:~$ ls -arlt /proc/$$/exe
lrwxrwxrwx 1 cheako cheako 0 May 15 12:42 /proc/30288/exe -> 
/home/cheako/bash
cheako@www:~$ rm bash
cheako@www:~$ ls -arlt /proc/$$/exe
lrwxrwxrwx 1 cheako cheako 0 May 15 12:42 /proc/30288/exe -> 
/home/cheako/bash (deleted)

So /proc/$$/exe has some implementation issues.



