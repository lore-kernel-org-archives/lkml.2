Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0HHXQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 19:16:10 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:51834 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755007Ab0HHXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 19:16:08 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] BFS CPU scheduler v0.323 for 2.6.35
Date: Mon, 9 Aug 2010 09:15:57 +1000
User-Agent: KMail/1.9.9
References: <201008071007.09904.kernel@kolivas.org>
In-Reply-To: <201008071007.09904.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008090915.57236.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010 10:07:09 am Con Kolivas wrote:
> This is to announce the availability of the updated BFS CPU scheduler for
> linux kernel v2.6.35.
>
>
> http://ck.kolivas.org/patches/bfs/2.6.35-sched-bfs-323.patch


In response to requests I get for some kind of basic benchmarks, attached are 
the kernbench results on a quad core Q9650 of 2.6.35 and 2.6.35-ck1, same 
config. (Summary, BFS slightly slower -j2, and slightly faster on -j1 , -j4 
and -j). This benchmark is not remotely meant to be a comprehensive summary 
of performance, but a simple regression test I do regularly. While the 
throughput of BFS has decreased slightly since dropping the rr interval, it 
is still performing well. But then latency is my prime concern. On the -ck1 
release thread I will post some interbench results as well, addressing this.


Thu Aug  5 20:59:36 EST 2010
2.6.35
Average Single threaded Run (std deviation):
Elapsed Time 89.302 (0.0396232)
User Time 78.272 (0.0593296)
System Time 10.676 (0.060663)
Percent CPU 99 (0)
Context Switches 5537 (17.6352)
Sleeps 12383.8 (55.1788)

Average Half load -j 2 Run (std deviation):
Elapsed Time 45.56 (0.100995)
User Time 78.336 (0.0756968)
System Time 10.96 (0.0935414)
Percent CPU 195.6 (0.547723)
Context Switches 5462.2 (16.5136)
Sleeps 12578 (13.0958)

Average Optimal load -j 4 Run (std deviation):
Elapsed Time 25.632 (0.131985)
User Time 79.706 (1.44625)
System Time 11.46 (0.535703)
Percent CPU 279 (87.9192)
Context Switches 7780.7 (2444.47)
Sleeps 12750.8 (192.797)

Average Maximal load -j Run (std deviation):
Elapsed Time 26.65 (0.0244949)
User Time 81.372 (2.70062)
System Time 11.92 (0.800206)
Percent CPU 307.867 (82.1878)
Context Switches 12080.7 (6592.71)
Sleeps 12632.1 (233.545)

Thu Aug  5 21:13:03 EST 2010
2.6.35-ck1
Average Single threaded Run (std deviation):
Elapsed Time 89.05 (0.0324037)
User Time 79.514 (0.0890505)
System Time 9.3 (0.103682)
Percent CPU 99 (0)
Context Switches 210.4 (12.5419)
Sleeps 14390.6 (11.1041)

Average Half load -j 2 Run (std deviation):
Elapsed Time 45.826 (0.0931665)
User Time 79.95 (0.0620484)
System Time 9.772 (0.0576194)
Percent CPU 195.2 (0.447214)
Context Switches 217 (18.775)
Sleeps 14467.6 (47.8153)

Average Optimal load -j 4 Run (std deviation):
Elapsed Time 25.598 (0.109179)
User Time 81.265 (1.38736)
System Time 10.247 (0.50339)
Percent CPU 279.5 (88.8673)
Context Switches 4438.1 (4449.75)
Sleeps 14033.3 (466.044)

Average Maximal load -j Run (std deviation):
Elapsed Time 26.408 (0.0614003)
User Time 82.7227 (2.40661)
System Time 10.5467 (0.59639)
Percent CPU 308.333 (82.8162)
Context Switches 7810.2 (6091.3)
Sleeps 13889.3 (445.423)

--
-ck
