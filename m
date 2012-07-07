Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2GGWB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 18:01:28 -0400
Received: from plane.gmane.org ([80.91.229.3]:38369 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab2GGWB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 18:01:27 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleksandr Natalenko <pfactum@gmail.com>
Subject: Re: [PATCH]RIFS-V3-Test For 3.4.x kernel.
Date: Sun, 08 Jul 2012 01:01:14 +0300
Message-ID: <jtabja$fhs$1@dough.gmane.org>
References: <CANQmPXibzo2OVPorHX3dcgbDFPnr=3FPm5Bu1-DbthSykzkJcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 160-249-113-92.pool.ukrtel.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
In-Reply-To: <CANQmPXibzo2OVPorHX3dcgbDFPnr=3FPm5Bu1-DbthSykzkJcA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please make some chart to visually compare latencies with CFS?

Also, has RIFS got cgroups support?

07.07.12 23:58, Chen написав(ла):
> 1. Benchmark:
> [admin@localhost ~]$ latt -c255 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=255
> Entries logged: 1020
> 
> Wakeup averages
> -------------------------------------
> 	Max		  106549 usec
> 	Avg		    1446 usec
> 	Stdev		    6182 usec
> 	Stdev mean	     194 usec
> 
> Work averages
> -------------------------------------
> 	Max		 2793229 usec
> 	Avg		 2189141 usec
> 	Stdev		  351389 usec
> 	Stdev mean	   11002 usec
> [admin@localhost ~]$ latt -c128 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=128
> Entries logged: 768
> 
> Wakeup averages
> -------------------------------------
> 	Max		   70824 usec
> 	Avg		    1761 usec
> 	Stdev		    5074 usec
> 	Stdev mean	     183 usec
> 
> Work averages
> -------------------------------------
> 	Max		 1464295 usec
> 	Avg		 1163262 usec
> 	Stdev		  210801 usec
> 	Stdev mean	    7607 usec
> [admin@localhost ~]$ latt -c64 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=64
> Entries logged: 640
> 
> Wakeup averages
> -------------------------------------
> 	Max		   53780 usec
> 	Avg		    1375 usec
> 	Stdev		    4772 usec
> 	Stdev mean	     189 usec
> 
> Work averages
> -------------------------------------
> 	Max		  797045 usec
> 	Avg		  596825 usec
> 	Stdev		  111695 usec
> 	Stdev mean	    4415 usec
> [admin@localhost ~]$ latt -c32 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=32
> Entries logged: 480
> 
> Wakeup averages
> -------------------------------------
> 	Max		   86032 usec
> 	Avg		    2147 usec
> 	Stdev		    7659 usec
> 	Stdev mean	     350 usec
> 
> Work averages
> -------------------------------------
> 	Max		  374303 usec
> 	Avg		  309004 usec
> 	Stdev		   43155 usec
> 	Stdev mean	    1970 usec
> [admin@localhost ~]$ latt -c16 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=16
> Entries logged: 320
> 
> Wakeup averages
> -------------------------------------
> 	Max		   41166 usec
> 	Avg		    1150 usec
> 	Stdev		    4706 usec
> 	Stdev mean	     263 usec
> 
> Work averages
> -------------------------------------
> 	Max		  178917 usec
> 	Avg		  155367 usec
> 	Stdev		   16074 usec
> 	Stdev mean	     899 usec
> [admin@localhost ~]$ latt -c8 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=8
> Entries logged: 184
> 
> Wakeup averages
> -------------------------------------
> 	Max		   20256 usec
> 	Avg		     585 usec
> 	Stdev		    2306 usec
> 	Stdev mean	     170 usec
> 
> Work averages
> -------------------------------------
> 	Max		   88262 usec
> 	Avg		   75957 usec
> 	Stdev		    7102 usec
> 	Stdev mean	     524 usec
> [admin@localhost ~]$ latt -c4 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=4
> Entries logged: 104
> 
> Wakeup averages
> -------------------------------------
> 	Max		    7950 usec
> 	Avg		     663 usec
> 	Stdev		    1719 usec
> 	Stdev mean	     169 usec
> 
> Work averages
> -------------------------------------
> 	Max		   50647 usec
> 	Avg		   38685 usec
> 	Stdev		    4053 usec
> 	Stdev mean	     397 usec
> [admin@localhost ~]$ latt -c2 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=2
> Entries logged: 54
> 
> Wakeup averages
> -------------------------------------
> 	Max		      33 usec
> 	Avg		       9 usec
> 	Stdev		       5 usec
> 	Stdev mean	       1 usec
> 
> Work averages
> -------------------------------------
> 	Max		   21700 usec
> 	Avg		   20590 usec
> 	Stdev		     258 usec
> 	Stdev mean	      35 usec
> [admin@localhost ~]$ latt -c1 sleep 10
> 
> Parameters: min_wait=100ms, max_wait=500ms, clients=1
> Entries logged: 27
> 
> Wakeup averages
> -------------------------------------
> 	Max		      22 usec
> 	Avg		       9 usec
> 	Stdev		       3 usec
> 	Stdev mean	       1 usec
> 
> Work averages
> -------------------------------------
> 	Max		   20614 usec
> 	Avg		   20162 usec
> 	Stdev		     125 usec
> 	Stdev mean	      24 usec
> 
> 
> 
> RIFS-V3 is the new name of RIFS-ES. It looks like CFS. but with RIFS,
> the latency is much lower.
> 



