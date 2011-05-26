Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab1EZJPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:15:40 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51518 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1EZJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:15:39 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 11:15:21 +0200
In-Reply-To: <20110523153848.GC2310@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306401337.27271.3.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> Please see attached for a script to poll at 15-second intervals.

0) The output from collectdebugfs.sh is pasted below. In this case the "CFQ
crash" occurred at "May 26 10:47:07".

1) Big friendly warning: the "CFQ crash" that occurred while running
your script didn't happen in a clean session. Not at all! It actually
happened after (summarized a bit):
- two "CFQ crashes" with the patch for Jens' first idea;
- switching to deadline
- removing cfq_iosched
- recompiling cfq-iosched.ko (to revert Jens' patch)
- installing cfq_iosched.ko
- inserting cfq_iosched
- switching back to cfq again

So if this makes you doubt the validity of the data I collected, which I
guess it could, I'd be happy to try again in a clean session (ie, after
a reboot).

2) Output:
Thu May 26 10:43:29 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=554580  gpnum=554581
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=554582 g=554583 s=2 jfq=2 j=2580 nfqs=246266/nfqsng=0(246266) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6869485 j=2580 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=554585 g=554586 pq=0 pqc=554584 qp=1 dt=7848133/1 dn=0 df=40 of=0
ri=12566 ql=6 b=10 ci=1329766 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7848133/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1818464 qsp=166998 rpq=396272 cbr=691 cng=93496 gpc=94571 gps=0
nf=13093 nn=1220341
rcu_bh:
  0 np=1220341 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1203345
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:43:44 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=559354  gpnum=559355
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=559358 g=559359 s=2 jfq=3 j=6161 nfqs=248249/nfqsng=0(248249) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6884814 j=6161 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=559362 g=559363 pq=0 pqc=559361 qp=1 dt=7854289/1 dn=0 df=40 of=0
ri=12596 ql=4 b=10 ci=1342505 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7854289/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1824426 qsp=167950 rpq=399419 cbr=694 cng=93931 gpc=94850 gps=0
nf=13137 nn=1222395
rcu_bh:
  0 np=1222395 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1205399
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:43:59 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=570906  gpnum=570907
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=570916 g=570917 s=2 jfq=3 j=9d4e nfqs=254774/nfqsng=0(254774) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6900155 j=9d4e nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=570921 g=570922 pq=0 pqc=570920 qp=1 dt=7859875/1 dn=0 df=40 of=0
ri=12606 ql=5 b=10 ci=1368036 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7859875/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1833555 qsp=169800 rpq=405228 cbr=715 cng=94910 gpc=95245 gps=0
nf=13149 nn=1224308
rcu_bh:
  0 np=1224308 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1207312
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:44:15 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=581243  gpnum=581244
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=581249 g=581250 s=2 jfq=2 j=d997 nfqs=260206/nfqsng=0(260206) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6915588 j=d997 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=581252 g=581253 pq=0 pqc=581251 qp=1 dt=7865933/1 dn=0 df=41 of=0
ri=12617 ql=6 b=10 ci=1390017 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7865933/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1842728 qsp=171719 rpq=410839 cbr=725 cng=95777 gpc=95677 gps=0
nf=13165 nn=1226545
rcu_bh:
  0 np=1226545 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1209549
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:44:30 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=593539  gpnum=593540
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=593552 g=593553 s=2 jfq=3 j=1597 nfqs=266219/nfqsng=0(266219) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6930948 j=1597 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=593557 g=593558 pq=0 pqc=593556 qp=1 dt=7870313/1 dn=0 df=42 of=0
ri=12639 ql=6 b=10 ci=1422737 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7870313/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1852849 qsp=173694 rpq=417772 cbr=734 cng=96590 gpc=95945 gps=0
nf=13190 nn=1228618
rcu_bh:
  0 np=1228618 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1211622
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:44:46 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=601780  gpnum=601781
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=601783 g=601784 s=2 jfq=3 j=51b6 nfqs=270338/nfqsng=0(270338) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6946339 j=51b6 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=601786 g=601787 pq=0 pqc=601785 qp=1 dt=7874647/1 dn=0 df=42 of=0
ri=12971 ql=10 b=10 ci=1443173 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7874647/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1863333 qsp=177584 rpq=422912 cbr=749 cng=97218 gpc=96255 gps=0
nf=13619 nn=1232580
rcu_bh:
  0 np=1232580 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1215584
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:45:01 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=609841  gpnum=609842
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=609850 g=609851 s=2 jfq=2 j=8dd5 nfqs=273748/nfqsng=0(273748) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6961730 j=8dd5 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=609853 g=609854 pq=0 pqc=609852 qp=1 dt=7879015/1 dn=0 df=42 of=0
ri=13281 ql=10 b=10 ci=1463867 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7879015/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1874562 qsp=181352 rpq=428551 cbr=761 cng=97850 gpc=96610 gps=0
nf=14023 nn=1236767
rcu_bh:
  0 np=1236767 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1219771
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:45:16 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=617798  gpnum=617799
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=617801 g=617802 s=2 jfq=3 j=c9f3 nfqs=277130/nfqsng=0(277130) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6977120 j=c9f3 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=617812 g=617813 pq=0 pqc=617811 qp=1 dt=7884079/1 dn=0 df=42 of=0
ri=13494 ql=3 b=10 ci=1483693 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7884079/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1886008 qsp=184720 rpq=433990 cbr=770 cng=98567 gpc=97047 gps=0
nf=14341 nn=1241293
rcu_bh:
  0 np=1241293 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1224297
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:45:32 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=625561  gpnum=625562
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=625567 g=625568 s=2 jfq=3 j=5d3 nfqs=281021/nfqsng=0(281021) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-6992448 j=5d3 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=625578 g=625579 pq=0 pqc=625577 qp=1 dt=7888495/1 dn=0 df=42 of=0
ri=13864 ql=6 b=10 ci=1503026 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7888495/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1896278 qsp=188883 rpq=438949 cbr=777 cng=99121 gpc=97317 gps=0
nf=14796 nn=1245318
rcu_bh:
  0 np=1245318 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1228322
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:45:47 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=633312  gpnum=633313
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=633324 g=633325 s=2 jfq=1 j=41a7 nfqs=284960/nfqsng=0(284960) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7007764 j=41a7 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=633336 g=633337 pq=0 pqc=633335 qp=1 dt=7892507/1 dn=0 df=42 of=0
ri=14241 ql=5 b=10 ci=1522479 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7892507/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1906914 qsp=193302 rpq=443888 cbr=783 cng=99667 gpc=97585 gps=0
nf=15282 nn=1249709
rcu_bh:
  0 np=1249709 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1232713
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:46:02 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=641266  gpnum=641267
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=641276 g=641277 s=2 jfq=3 j=7d7d nfqs=288841/nfqsng=0(288841) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7023082 j=7d7d nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=641284 g=641285 pq=0 pqc=641283 qp=1 dt=7896725/1 dn=0 df=42 of=0
ri=14601 ql=1 b=10 ci=1542099 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7896725/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1917497 qsp=197518 rpq=449040 cbr=789 cng=100209 gpc=97845 gps=0
nf=15738 nn=1253876
rcu_bh:
  0 np=1253876 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1236880
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:46:18 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=649448  gpnum=649448
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=649453 g=649454 s=2 jfq=3 j=b955 nfqs=292503/nfqsng=0(292503) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7038402 j=b955 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=649468 g=649469 pq=1 pqc=649468 qp=1 dt=7901627/1 dn=0 df=42 of=0
ri=14855 ql=1 b=10 ci=1562352 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7901627/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1928207 qsp=201146 rpq=454475 cbr=797 cng=100805 gpc=98171 gps=0
nf=16080 nn=1257879
rcu_bh:
  0 np=1257879 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1240883
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:46:33 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=657553  gpnum=657554
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=657559 g=657560 s=2 jfq=3 j=f5e5 nfqs=295995/nfqsng=0(295995) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7053906 j=f5e5 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=657564 g=657565 pq=0 pqc=657563 qp=1 dt=7907237/1 dn=0 df=42 of=0
ri=15111 ql=4 b=10 ci=1582002 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7907237/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1939294 qsp=204834 rpq=459994 cbr=804 cng=101419 gpc=98518 gps=0
nf=16431 nn=1262128
rcu_bh:
  0 np=1262128 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1245132
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:46:49 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=665689  gpnum=665690
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=665692 g=665693 s=2 jfq=3 j=32a6 nfqs=299855/nfqsng=0(299855) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7069459 j=32a6 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=665700 g=665701 pq=0 pqc=665699 qp=1 dt=7911759/1 dn=0 df=42 of=0
ri=15459 ql=5 b=10 ci=1601915 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7911759/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1950196 qsp=209090 rpq=465319 cbr=814 cng=101986 gpc=98794 gps=0
nf=16887 nn=1266396
rcu_bh:
  0 np=1266396 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1249400
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:47:04 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=674282  gpnum=674283
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=674286 g=674287 s=2 jfq=1 j=6ef9 nfqs=303532/nfqsng=0(303532) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7084902 j=6ef9 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=674300 g=674301 pq=0 pqc=674299 qp=1 dt=7916737/1 dn=0 df=42 of=0
ri=15670 ql=5 b=10 ci=1622776 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7916737/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1961236 qsp=212684 rpq=471110 cbr=822 cng=102605 gpc=99130 gps=0
nf=17168 nn=1270401
rcu_bh:
  0 np=1270401 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1253405
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:47:20 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=682249  gpnum=682250
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=682257 g=682258 s=2 jfq=3 j=aad8 nfqs=307404/nfqsng=0(307404) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7100229 j=aad8 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=682260 g=682261 pq=0 pqc=682259 qp=1 dt=7921175/1 dn=0 df=42 of=0
ri=16003 ql=4 b=10 ci=1642246 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7921175/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1971567 qsp=216816 rpq=476234 cbr=830 cng=103139 gpc=99383 gps=0
nf=17588 nn=1274393
rcu_bh:
  0 np=1274393 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1257397
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:47:35 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=689950  gpnum=689951
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=689955 g=689956 s=2 jfq=2 j=e69e nfqs=311206/nfqsng=0(311206) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7115531 j=e69e nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=689964 g=689965 pq=0 pqc=689963 qp=1 dt=7925441/1 dn=0 df=42 of=0
ri=16397 ql=5 b=10 ci=1661655 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7925441/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1982355 qsp=221269 rpq=481281 cbr=835 cng=103658 gpc=99618 gps=0
nf=18095 nn=1278868
rcu_bh:
  0 np=1278868 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1261872
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:47:50 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=698992  gpnum=698993
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=698998 g=698999 s=2 jfq=3 j=2298 nfqs=313944/nfqsng=0(313944) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7130885 j=2298 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=699006 g=699007 pq=0 pqc=699005 qp=1 dt=7928625/1 dn=0 df=42 of=0
ri=16821 ql=4 b=10 ci=1693458 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7928625/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=1994830 qsp=225627 rpq=488590 cbr=837 cng=103889 gpc=99736 gps=0
nf=18667 nn=1283111
rcu_bh:
  0 np=1283111 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1266115
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:48:06 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=711432  gpnum=711433
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=711441 g=711441 s=0 jfq=1 j=5eaf nfqs=314929/nfqsng=0(314929) fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7146268 j=5eaf nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=711443 g=711444 pq=0 pqc=711442 qp=1 dt=7930563/1 dn=0 df=42 of=0
ri=16851 ql=9 b=10 ci=1748424 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7930563/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=2008491 qsp=226909 rpq=500253 cbr=837 cng=104041 gpc=99813 gps=0
nf=18710 nn=1284837
rcu_bh:
  0 np=1284837 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1267841
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost

Thu May 26 10:48:21 CEST 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=719902  gpnum=719903
rcu_bh: completed=-114  gpnum=4294967182
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=719907 g=719908 s=2 jfq=2 j=9aa3 nfqs=315817/nfqsng=0(315817) fqlh=0
1/1 ..>.. 0:63 ^0    
1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
rcu_bh:
c=4294967182 g=4294967182 s=0 jfq=-7161616 j=9aa3 nfqs=50/nfqsng=0(50)
fqlh=0
0/1 ..>.. 0:63 ^0    
0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2
0/0 ..>.. 48:63 ^3    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=719915 g=719916 pq=0 pqc=719914 qp=1 dt=7934501/1 dn=0 df=42 of=0
ri=16854 ql=4 b=10 ci=1780327 co=0 ca=0
rcu_bh:
  0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7934501/1 dn=0
df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=2020635 qsp=227848 rpq=507995 cbr=838 cng=104418 gpc=100105 gps=0
nf=18720 nn=1288559
rcu_bh:
  0 np=1288559 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1271563
/sys/kernel/debug/rcu/rcutorture:
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
no /sys/kernel/debug/rcu/rcuboost


Paul Bolle

