Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1JAFz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 01:55:56 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:55178 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab1JAFzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 01:55:49 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 01:55:48 EDT
Message-Id: <6.2.5.6.2.20111001012019.05c05b80@flumedata.com>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Sat, 01 Oct 2011 01:30:47 -0400
To: linux-kernel@vger.kernel.org
From: starlight@binnacle.cx
Subject: big picture UDP/IP performance question re 2.6.18 ->
  2.6.32
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm hoping someone can provide a brief big-picture
perspective on the dramatic UDP/IP multicast
receive performance reduction from 2.6.18 to
2.6.32 that I just benchmarked.

Have helped out in the past, mainly by identifying
a bug in hugepage handling and providing a solid
testcase that helped in quickly identifying and
correcting the problem.

Have a very-high-volume UDP multicast receiver
application.  Just finished benchmarking latest RH
variant of 2.6.18 against latest RH 2.6.32 and
vanilla 2.6.32.27 on the same 12 core Opteron
6174 processor system, one CPU.

Application reads on 250 sockets with large socket
buffer maximums.  Zero data loss.  Four Intel
'e1000e' 82571 gigabit NICs, or two Intel 'igb'
82571 gigabit NICs or two Intel 82599 10 gigabit
NICs.  Results similar on all.

With 2.6.18, system CPU is reported in
/proc/<pid>/stat as 25% of total.  With 2.6.32,
system consumption is 45% with the same exact data
playback test.  Jiffy count for user CPU is same
for both kernels, but .32 system CPU is double
.18 system CPU.

Overall maximum performance capacity is reduced in
proportion to the increased system overhead.

------

My question is why is the performance significantly
worse in the more recent kernels?  Apparently
network performance is worse for TCP by about the
same amount--double the system overhead for the
same amount of work.

http://www.phoronix.com/scan.php?page=article&item=linux_2612_2637&num=6

Is there any chance that network performance will
improve in future kernels?  Or is the situation
a permanent trade-off for security, reliability
or scalability reasons?

Thank you very much.

