Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1LHScr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:32:47 -0500
Received: from nine.vfemail.net ([108.76.175.9]:55347 "EHLO vfemail.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625Ab1LHScp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:32:45 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 13:32:43 EST
Date: Thu, 8 Dec 2011 19:25:36 +0100
From: Matthias Matiak <netzpython@mail-on.us>
To: linux-kernel@vger.kernel.org
Subject: UDF: write hangs w/ certain applications (2.6.38...Git)
Message-Id: <20111208192536.1ee205dc.netzpython@mail-on.us>
Organization: NEXUS Research Corporation
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel hacker,
there is a problem while trying to write to an UDF filesystem with 
some userspace applications like "tar" or "dar" since linux 2.6.28 till currrent git
at least on x86/x86_64. The process who wants to write hangs at D state forever,
and no data were saved on the blockdev or image file actually. 
There is no chance of killing that prozess, unmount that UDF filesystem or 
reboot/shutdown the box in a clean fashion. 
Other tools like "cp" or piping stuff via shell works perfectly however. 

This problem does not occur with linux <= 2.6.37

No errors are shown by dmesg, except:
"INFO: task dar:$PID blocked for more than 120 seconds."
followed by a trace. Turning on udf debugging does not show any new infos
after mounting the filesystem. 

Steps to reproduce:
0) Fire up a virtual machine 
1) boot a (x86) linux kernel 2.6.38 till current GIT
2) create an image file or choose any block device, format it as UDF with mkudffs and mount somewhere.
3) install "dar", a UNIX backup tool ( http://dar.linux.free.fr/ ).
4) Try to create an archive. e.g.: 
	dar --verbose --create /path/to/testarchive_on_UDF --fs-root /sbin 
(replace /sbin with any path with some files within that you like)
5) dar will hang now almost instantly.

This behavior was reported by someone else already on debian bug tracking system
some weeks ago, but with no responses so far.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=647204
You can find additional information there.

Would be great if someone could investigate this issue further. :)


Best regards
Matthias

--
Feel free to send me mail or patches directly!










-------------------------------------------------
This message sent via VFEmail.net
http://www.vfemail.net
$14.95 Lifetime accounts!  15GB disk!  
Commercial Mail Options!   No bandwidth quotas!
 
