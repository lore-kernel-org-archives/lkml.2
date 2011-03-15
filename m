Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1CONZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:25:30 -0400
Received: from gmmr6.centrum.cz ([90.183.38.131]:50473 "EHLO gmmr6.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab1CONZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:25:28 -0400
To: <linux-kernel@vger.kernel.org>
Subject: Regression from 2.6.36
Date: Tue, 15 Mar 2011 14:25:27 +0100
From: "azurIt" <azurit@pobox.sk>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-Id: <20110315132527.130FB80018F1@mail1005.cent>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

we are successfully running several very busy web servers on 2.6.32.* and
few days ago I decided to upgrade to 2.6.37 (mainly because of blkio cgroup).
I installed 2.6.37.2 on one of the servers and very strange things started to
happen with Apache web server.

We are using Apache with MPM-ITK ( http://mpm-itk.sesse.net/ ) so it is doing
lots of 'fork' and lots of 'setuid'. I have also noticed that problem is
happening only on very busy servers.

Everything is ok when Apache is started but as time is passing by, its 'root'
processes (Apache processes running under root) are consuming more and more CPU.
Finally, the whole server becames very unstable and Apache must be restarted.
This is repeating until the load on web sites is much lower (usually on 22:00).
Sometimes it takes 3 hours when restart is needed, sometimes only 1 hour (again,
depends on load on web sites). Here is the graph of CPU utilization showing the
problem (red color), Apache was REstarted at 8:11 and 9:35:
http://watchdog.sk/lkml/cpu-problem.png

Here is how it looks on htop:
http://watchdog.sk/lkml/htop.jpg

And finally here is how it looks with older kernels (yes, when i install older
kernel, problem is gone), notice also that I/O wait is much lower and nicer
(blue color):
http://watchdog.sk/lkml/cpu-ok.png

I was also strace-ing Apache processes which were doing problems, here it is:
http://watchdog.sk/lkml/strace.txt

I'm not 100% sure but I think that CPU was consumed on 'futex' lines.

I tried several kernel versions and find out that everything BEFORE 2.6.36 is
NOT affected and everything AFTER 2.6.36 (included) is affected.

Versions which I tried and were NOT affected by this problem:
2.6.32.*
2.6.35.11

Versions which I tried and were affected by this problem:
2.6.36
2.6.36.4
2.6.37.2
2.6.37.3
2.6.38-rc8 (final version was not released yet)

All tests were made on vanilla kernels on Debian Lenny with this config:
http://watchdog.sk/lkml/config

Do you need any other information from me ? I'm able to try other versions or
patches but, please, take into account that I have to do this on _production_
server (I failed to reproduce it in testing environment). Also, I'm able to try
only one kernel per day.

Thank you !

azurit
