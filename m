Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1KCFpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:45:45 -0400
Received: from home.kolivas.org ([59.167.196.135]:52469 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916Ab1KCFpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:45:44 -0400
From: Con Kolivas <con@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] BFS CPU scheduler v0.414 for linux-3.1
Date: Thu, 03 Nov 2011 16:45:02 +1100
Message-ID: <3381942.VZfVBkKWDX@quad>
User-Agent: KMail/4.7.2 (Linux/3.1.0-ck1; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce a resync of the BFS CPU scheduler for the latest linux 
kernel.

http://ck.kolivas.org/patches/bfs/3.1.0/3.1-sched-bfs-414.patch

A single shared runqueue O(n) strict fairness, deterministic, earliest 
effective virtual deadline first design.

Excellent throughput and latency for 1 to many CPUs on desktop and server
commodity hardware.

Not recommended for 4096 cpus.

Scalability is optimal when your workload is equal to the number of CPUs on
bfs. ie you should ONLY do make -j4 on quad core, -j2 on dual core and so on.

Features SCHED_IDLEPRIO and SCHED_ISO scheduling policies as well.
You do NOT need to use these policies for good performance, they are purely
optional for even better performance in extreme conditions.

To run something idleprio, use schedtool like so:

schedtool -D -e make -j4

To run something isoprio, use schedtool like so:

schedtool -I -e amarok

Includes accurate sub-tick accounting of tasks so userspace reported
cpu usage may be very different if you have very short lived tasks.


Enjoy.
-- 
-ck
