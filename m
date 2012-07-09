Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2GISDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab2GISDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:03:34 -0400
Date: Mon, 9 Jul 2012 14:03:28 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120709180328.GA4105@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@vrfy.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the format of the oom-killer output seems to have changed, and
now it spews stuff like..

[49461.758070] lowmem_reserve[]:
[49461.758071]  0
[49461.758071]  2643
[49461.758071]  3878
[49461.758072]  3878
[49461.758072] 
[49461.758072] Node 0 
[49461.758075] DMA32 free:50432kB min:45888kB low:57360kB high:68832kB active_anon:1980216kB inactive_anon:494260kB active_file:276kB inactive_file:1064kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2707204kB mlocked:0kB dirty:0kB writeback:82756kB mapped:0kB shmem:0kB slab_reclaimable:15392kB slab_unreclaimable:118172kB kernel_stack:12672kB pagetables:10744kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:9756 all_unreclaimable? yes
[49461.758076] lowmem_reserve[]:
[49461.758076]  0
[49461.758076]  0
[49461.758077]  1234
[49461.758077]  1234
[49461.758077] 
[49461.758078] Node 0 
[49461.758080] Normal free:21208kB min:21424kB low:26780kB high:32136kB active_anon:448068kB inactive_anon:446924kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):972kB isolated(file):0kB present:1264032kB mlocked:0kB dirty:0kB writeback:19580kB mapped:516kB shmem:5532kB slab_reclaimable:34960kB slab_unreclaimable:110764kB kernel_stack:54392kB pagetables:11596kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:16064 all_unreclaimable? yes
[49461.758080] lowmem_reserve[]:
[49461.758080]  0
[49461.758081]  0
[49461.758081]  0
[49461.758081]  0
[49461.758082] 
[49461.758082] Node 0 
[49461.758082] DMA: 
[49461.758085] 0*4kB 
[49461.758086] 0*8kB 
[49461.758086] 3*16kB 
[49461.758086] 1*32kB 
[49461.758087] 3*64kB 
[49461.758087] 3*128kB 
[49461.758087] 3*256kB 
[49461.758088] 2*512kB 
[49461.758088] 3*1024kB 
[49461.758089] 3*2048kB 
[49461.758089] 1*4096kB 
[49461.758089] = 15760kB
[49461.758090] Node 0 
[49461.758090] DMA32: 
[49461.758091] 166*4kB 
[49461.758091] 74*8kB 
[49461.758092] 162*16kB 
[49461.758092] 314*32kB 
[49461.758093] 337*64kB 
[49461.758093] 82*128kB 
[49461.758094] 8*256kB 
[49461.758094] 1*512kB 
[49461.758094] 1*1024kB 
[49461.758095] 0*2048kB 
[49461.758095] 0*4096kB 
[49461.758096] = 49544kB
[49461.758096] Node 0 
[49461.758096] Normal: 
[49461.758097] 847*4kB 
[49461.758097] 1834*8kB 
[49461.758098] 0*16kB 
[49461.758098] 5*32kB 
[49461.758098] 3*64kB 
[49461.758099] 2*128kB 
[49461.758099] 1*256kB 
[49461.758100] 0*512kB 
[49461.758100] 0*1024kB 
[49461.758100] 1*2048kB 
[49461.758101] 0*4096kB 
[49461.758101] = 20972kB


Does the oom-killer code need modifying, or the printk code ?
I know there's been some regressions in this area recently, but this is still
happening on the current tree (8c84bf4166a4698296342841a549bbee03860ac0)

	Dave

