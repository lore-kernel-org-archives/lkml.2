Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0ECUXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:23:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60265 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab0ECUXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:23:50 -0400
MIME-Version: 1.0
Message-ID: <18849d97-2fee-43a0-a3ea-9132f8163609@default>
Date: Mon, 3 May 2010 13:21:47 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: venki@google.com, mingo@redhat.com
Subject: [RFC] Exposing TSC "reliability" to userland
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BDF309B.00F9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a patch posted late last year by Venki: 

http://lkml.org/lkml/2009/12/17/360

it was noted that some systems that specify the "Invariant TSC"
bit in CPUID (on recent processors) are sadly not guaranteed to
have synchronized TSCs.  As a result, Ingo's check_tsc_warp() is
executed; if the warp test passes, the kernel uses TSC
as clocksource and, if it doesn't pass, the kernel marks
the TSC as unstable and chooses a different clocksource.

Whether the kernel deems TSC to be reliable or not is a very
useful piece of information to userland, e.g. to certain
enterprise apps such the Oracle DB, some JVM's, etc.  If
TSC IS reliable, rdtsc can be used by many of these
enterprise applications in many situations in place of a
gettimeofday call.  Rdtsc can be much faster even than
a vsyscall and it is certainly much much faster when,
for one reason or another, vsyscall is not enabled.
This can make a huge performance difference in real
benchmarks when timestamps are frequently taken (10%
benchmark performance improvement was measured using
rdtsc vs gettimeofday syscall).

Running a warp test in userland is not nearly as accurate
as the warp test run by the kernel.  So it makes sense to expose
the results of the kernel warp test to userland, maybe
through /sys/devices/system/clocksource/tsc_reliable

Comments?
