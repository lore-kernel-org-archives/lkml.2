Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1EMHjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:39:14 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:54735 "HELO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757105Ab1EMHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:39:12 -0400
MIME-Version: 1.0
Date: Fri, 13 May 2011 09:39:08 +0200
Message-ID: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
Subject: Sched_autogroup and niced processes
From: Carl-Johan Kjellander <carl-johan@klarna.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been running seti@home niced to 19 in the background since 1999
without any problems. No noticeable effect even when playing a movie
or a game. But since 2.6.38 the new fix-all-problems automatic
grouping has been messing a bit with me. These are some timed compiles
on my 8 cores.

time make -j12 # with seti@home running
real	4m16.753s
user	10m33.770s
sys	1m39.710s

time make -j12 # without seti@home running
real	2m12.480s
user	10m11.580s
sys	1m39.980s

echo 0 > /proc/sys/kernel/sched_autogroup_enabled
time make -j12 # no autogroup, seti@home running again
real	2m33.276s
user	10m37.540s
sys	1m43.190s

All compiles already had all files cached in RAM.

Now I can take the 10% performance hit, but not the 100% hit of
running stuff super niced in the background. Processes niced to 19
should only use spare cycles and not take up half of the cores even
with autogroup. I would really like to run autogroup since it is a
neat idea, but it can't mess up running niced processes in the
background which have been working fine for 12 years.

/Carl-Johan Kjellander
