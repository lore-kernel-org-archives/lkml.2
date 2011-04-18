Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab1DRIpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:45:36 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:37043 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1DRIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:45:27 -0400
Date: Mon, 18 Apr 2011 10:45:11 +0200
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-s390@vger.kernel.org, Stephen Powell <zlinuxman@wowway.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
Message-ID: <20110418084511.GA7786@hal>
References: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
 <20110416014811.GA6150@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416014811.GA6150@elie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 08:48:40PM -0500, Jonathan Nieder wrote:
> Hi,
> 
> Here's an oops that was reported to Debian[1].  It cannot be
> reproduced on demand but it is reproducible with enough time.  It did
> not appear on v2.6.32; it does appear on Debian 2.6.38-3 (which is
> based on gregkh's v2.6.38.2) and pristine v2.6.39-rc3, so looks like
> a regression.
> 
> Stephen Powell wrote:
> 
> > I installed linux-image-2.6.38-2-s390x version 2.6.38-3 on my up-to-date Wheezy
> > system today.  It runs in a virtual machine under z/VM 5.4.0 running in an LPAR
> > on an IBM z/890.  It IPLed just fine.  After the IPL, the system fell idle for a while.
> > Then a CRON job kicked off, which caused a page fault, which caused a kernel oops.
> > Here is the log:
> >
> > [ 2697.934752] Unable to handle kernel pointer dereference at virtual kernel address           (null)
> > [ 2697.982153] Oops: 0004 [#1] SMP
> > [ 2698.001730] Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dm_mod dasd_eckd_mod dasd_diag_mod dasd_mod
> > [ 2698.003407] CPU: 0 Not tainted 2.6.38-2-s390x #1
> > [ 2698.003430] Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> > [ 2698.003455] Krnl PSW : 0404200180000000 000000000002c03e (pfault_interrupt+0xa2/0x138)
> > [ 2698.021870]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> > [ 2698.021902] Krnl GPRS: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
> > [ 2698.021943]            000000001f962f78 0000000000518968 0000000090000002 000000001ff03280
> > [ 2698.021979]            0000000000000000 000000000064f000 000000001f962f78 0000000000002603
> > [ 2698.022016]            0000000006002603 0000000000000000 000000001ff7fe68 000000001ff7fe48
> > [ 2698.022096] Krnl Code: 000000000002c036: 5820d010            l       %r2,16(%r13)
> > [ 2698.051390]            000000000002c03a: 1832                lr      %r3,%r2
> > [ 2698.051407]            000000000002c03c: 1a31                ar      %r3,%r1 
> > [ 2698.051430]           >000000000002c03e: ba23d010            cs      %r2,%r3,16(%r13)
> > [ 2698.051448]            000000000002c042: a744fffc            brc     4,2c03a 
> > [ 2698.051466]            000000000002c046: a7290002            lghi    %r2,2
> > [ 2698.051486]            000000000002c04a: e320d0000024        stg     %r2,0(%r13)
> > [ 2698.051502]            000000000002c050: 07f0                bcr     15,%r0
> > [ 2698.051514] Call Trace:
> > [ 2698.051521] ([<000000001f962f78>] 0x1f962f78)
> > [ 2698.051537]  [<000000000001acda>] do_extint+0xf6/0x138                       
> > [ 2698.051555]  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
> > [ 2698.052373]  [<000000007d706e04>] 0x7d706e04
> > [ 2698.052387] Last Breaking-Event-Address:
> > [ 2698.052395]  [<0000000000000000>] 0x0
> > [ 2698.052406]
> > [ 2698.053263] Kernel panic - not syncing: Fatal exception in interrupt
> > [ 2698.053316] CPU: 0 Tainted: G      D      2.6.38-2-s390x #1
> > [ 2698.053502] Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
> > [ 2698.053516]        0000000000000000 000000001ff7fa70 0000000000000002 0000000000000000
> > [ 2698.053539]        000000001ff7fb10 000000001ff7fa88 000000001ff7fa88 0000000000397b9e
> > [ 2698.053576]        0000000000000001 0000000000000000 000000001ff03280 0000000000000000
> > [ 2698.053623]        0000000000000008 0000000000000000 000000000000000e 0000000000000078
> > [ 2698.053674]        000000001ff7faf0 0000000000011b36 000000001ff7fa70 000000001ff7fab8
> > [ 2698.053740] Call Trace:
> > [ 2698.053762] ([<0000000000011a60>] show_trace+0x5c/0xa4)
> > [ 2698.053801]  [<00000000003979de>] panic+0x9e/0x214
> > [ 2698.054443]  [<0000000000012046>] die+0x15e/0x170
> > [ 2698.054485]  [<000000000002c5d6>] do_no_context+0xd6/0xe0
> > [ 2698.054529]  [<000000000002cd52>] do_protection_exception+0x46/0x2a0
> > [ 2698.054577]  [<000000000039b208>] pgm_exit+0x0/0x4
> > [ 2698.054627]  [<000000000002c03e>] pfault_interrupt+0xa2/0x138
> > [ 2698.054679] ([<000000001f962f78>] 0x1f962f78)
> > [ 2698.056408]  [<000000000001acda>] do_extint+0xf6/0x138
> > [ 2698.056424]  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
> > [ 2698.056439]  [<000000007d706e04>] 0x7d706e04
> > HCPGIR450W CP entered; disabled wait PSW 00020001 80000000 00000000 0001DE26
> [...]
> 
> > On Thu, 14 Apr 2011 21:48:56 -0400 (EDT), Stephen Powell wrote:
> 
> >> The problem appears to be fixed in the latest vanilla upstream kernel
> >> source, which at the time of this writing is 2.6.39-rc3.
> >> ...
> >
> > Oops!  I spoke too soon.  I checked the server before I went to bed
> > last night, and it was still up at that time; but when I got up this
> > morning I checked it again, and it had crashed during the night with
> > the same protection exception at the same offset in the same function.
> > That's the trouble with these kind of bugs.
> 
> Ideas?

I guess this is caused by a bug in the module protection code for s390
which went into 2.6.38. Can you try if the following patch fixes it?

--Jan

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/mm/pageattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -24,12 +24,13 @@ static void change_page_attr(unsigned lo
 			WARN_ON_ONCE(1);
 			continue;
 		}
-		ptep = pte_offset_kernel(pmdp, addr + i * PAGE_SIZE);
+		ptep = pte_offset_kernel(pmdp, addr);
 
 		pte = *ptep;
 		pte = set(pte);
-		ptep_invalidate(&init_mm, addr + i * PAGE_SIZE, ptep);
+		ptep_invalidate(&init_mm, addr, ptep);
 		*ptep = pte;
+		addr += PAGE_SIZE;
 	}
 }
