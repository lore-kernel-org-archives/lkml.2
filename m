Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab0ECJXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:23:15 -0400
Received: from home.kolivas.org ([59.167.196.135]:44394 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0ECJXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:23:12 -0400
X-Greylist: delayed 1125 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 05:23:11 EDT
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS cpu scheduler v0.316
Date: Mon, 3 May 2010 19:04:22 +1000
User-Agent: KMail/1.12.4 (Linux/2.6.33-ck1; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005031904.22894.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to briefly announce the immediate availability of the desktop 
interactivity focused BFS CPU scheduler version 0.316 which is a minor bugfix.

The only changes since version 0.315 affect performance on uniprocessor 
machines. A long-standing bug was found that would prevent tasks being woken 
up and scheduled properly on very idle machines when woken up by network 
activity (and the like) only. This would cause great lag when the only 
activity happening on the machine was network based (such as a network based 
install or ssh session). 

Thanks to Byron Stanoszek for spotting the bug and testing the fix which has 
been present for some time (since bfs 0.232). Surprisingly, only 2 people have 
reported this bug in the last 5 months meaning either this was a rare 
workload, or there are very few uniprocessor BFS machines out there, or people 
just don't report bugs. I suspect it was a combination of all of the above.

The change to 0.316 will not have any effect on kernels built with SMP 
support. Fortunately, all pclinuxOS kernels (the largest current distribution 
using BFS in its kernels) are built with SMP support enabled so will not 
suffer from this bug. However, all -ck users for the last 2 kernels with 
kernels built with uniprocessor support will be affected. I will probably be 
providing new -ck kernels with this one bugfix in the near future.


Versions are available for 2.6.32 and 2.6.33

http://ck.kolivas.org/patches/bfs/2.6.32-sched-bfs-316.patch
http://ck.kolivas.org/patches/bfs/2.6.33-sched-bfs-316.patch

Also, Richard Ross has kindly provided a patch for 2.6.27 for hero HTC android 
users:
http://ck.kolivas.org/patches/bfs/Unofficial-BFS-316-HEROC-2.6.27.patch

Regards,
Con

-- 
-ck
