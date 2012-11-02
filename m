Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2KBHug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:50:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65150 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2KBHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:50:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6883"; a="3683339"
Message-ID: <50937B34.6050502@codeaurora.org>
Date: Fri, 02 Nov 2012 13:20:12 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: sysfs crashes while recursively checking file permissions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running one test on my ARM system which checks the sysfs file
system's whole directory recursively and checks its file permission.
While I perform this test, I face random (as in varies the nature of
crash sometimes) crashes like one mentioned below.


<1>[   67.442660] Unable to handle kernel paging request at virtual 
address efd3d794

<1>[   67.448840] pgd = da364000

<1>[   67.451529] [efd3d794] *pgd=00000000

<0>[   67.455092] Internal error: Oops: 5 [#1] PREEMPT SMP ARM

<4>[   67.460385] Modules linked in:

<4>[   67.463424] CPU: 1    Not tainted  
(3.4.0-perf-g45c04fe-00006-g8a5c5e2 #27)

<4>[   67.470382] PC is at rb_next+0x38/0x60

<4>[   67.474103] LR is at sysfs_readdir+0x1f8/0x288

<4>[   67.478528] pc : [<c02f7c50>]    lr : [<c01c1fe8>]    psr: a0000013

<4>[   67.478532] sp : d90adf10  ip : 00000078  fp : 0000000b

<4>[   67.489984] r10: 00004a0e  r9 : 00000004  r8 : 00000000

<4>[   67.495193] r7 : dbea2e00  r6 : 00000000  r5 : db9385c0  r4 : d8ada0c0

<4>[   67.501704] r3 : efd3d790  r2 : efd3d790  r1 : db9385d0  r0 : dbea2e50

<4>[   67.508216] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  
Segment user

<4>[   67.515333] Control: 10c5787d  Table: 5a56406a  DAC: 00000015

<4>[   67.521061]

<4>[   67.521063] PC: 0xc02f7bd0:

<4>[   67.525313] 7bd0  e1500002 05813008 15813004 e5902008 e3520000 
15921000 12011003 11831001

<4>[   67.533473] 7bf0  15821000 e5902004 e3520000 15921000 12011003 
11831001 15821000 e8900007

<4>[   67.541632] 7c10  e8830007 e12fff1e e5903000 e3c33003 e1500003 
03a03000 0a000010 e5903004

<4>[   67.549791] 7c30  e3530000 1a00000a ea000000 e1a00002 e5902000 
e3c22003 e2523000 0a000007

<4>[   67.557951] 7c50  e5921004 e1500001 0afffff7 ea000003 e1a03002 
e5932008 e3520000 1afffffb

<4>[   67.566112] 7c70  e1a00003 e12fff1e e92d4010 e1a04000 e5903004 
e5902008 e3530000 1a000003

<4>[   67.574271] 7c90  e2523000 05903000 03c33003 ea00000b e3520000 
0a000009 ebffffda e5902004

<4>[   67.582430] 7cb0  e1a03000 e3520000 11a03002 1a000003 e5932000 
e3c22003 e1540002 11a03002

<4>[   67.590592]

<4>[   67.590594] LR: 0xc01c1f68:

<4>[   67.594844] 1f68  e2833001 e1852f93 e3320000 1afffffa e59f00ec 
e5845078 eb16e059 e1c422d8

<4>[   67.603003] 1f88  e1a01008 e58da008 e58d600c e1cd20f0 e1a0200b 
e59d3024 e58d9010 e59d0020

<4>[   67.611163] 1fa8  e12fff33 e1a08000 e59f00b4 eb16e0fe e3580000 
ba000015 e5942028 e1a01007

<4>[   67.619323] 1fc8  e59d001c e3a03000 e58d5000 ebffff33 e2505000 
0a00000d e2850010 eb04d70b

<4>[   67.627483] 1fe8  e3500000 0a000005 e5903010 e2405010 e59d101c 
e1530001 1afffff6 ea000001

<4>[   67.635643] 2008  e1a05000 ea000001 e3550000 1affffbf e59f004c 
eb16e032 e1c422d8 e3520002

<4>[   67.643803] 2028  e2d31000 b3a03000 a3a03001 e3550000 13a05000 
02035001 e3550000 13a03000

<4>[   67.651963] 2048  13e02102 11c422f8 13a03000 15843078 e3a00000 
e28dd02c e8bd8ff0 c09e096e

<4>[   67.660123]

<4>[   67.660125] SP: 0xd90ade90:

<4>[   67.664376] de90  00000007 205bdf78 37362020 3234342e 5d363436 
d90a0020 d90ac000 c016f80c

<4>[   67.672535] deb0  d90adebc c02f7c50 a0000013 ffffffff d90adefc 
c077ca58 dbea2e50 db9385d0

<4>[   67.680694] ded0  efd3d790 efd3d790 d8ada0c0 db9385c0 00000000 
dbea2e00 00000000 00000004

<4>[   67.688854] def0  00004a0e 0000000b 00000078 d90adf10 c01c1fe8 
c02f7c50 a0000013 ffffffff

<4>[   67.697014] df10  db9385c0 00000000 00004a0e 00000000 00000004 
00000000 dbe02480 00000000

<4>[   67.705175] df30  d90adf80 c0172598 d8d87f08 d8ada0c0 dbdbe068 
c0172598 00000000 dbdbe000

<4>[   67.713334] df50  d90ac000 d90adf80 0000cb6c c017282c 83068137 
420670d0 00000000 00001068

<4>[   67.721493] df70  d8ada0c0 c000e068 00000000 c01729b4 420671e0 
420671c0 00000f58 ffffffea

<4>[   67.729654]

<4>[   67.729656] R0: 0xdbea2dd0:

<4>[   67.733907] 2dd0  dbe98300 daaf9b10 dbebb1d0 00000000 00000000 
2c53e300 c0c69208 00000003

<4>[   67.742067] 2df0  dbea2f50 40ed0001 000001e3 00000000 00000012 
00000000 dbe30c40 dbea2dc0

<4>[   67.750226] 2e10  dbe98391 daad60d0 dbebb210 00000000 00000000 
2c53e300 c0c69208 00000003

<4>[   67.758385] 2e30  dbea2f90 41ed0001 000001e3 00000000 00000003 
00000000 dbea2e00 c0a10df6

<4>[   67.766547] 2e50  efd3d791 db9385d0 db938010 00000000 00000000 
57c6bb9d c0c9c8a4 00000000

<4>[   67.774706] 2e70  00000000 81a40002 000001e4 00000000 00000001 
00000000 efd3d600 c09cd4b0

<4>[   67.782865] 2e90  dbea2f91 db937e10 dbea4010 00000000 00000000 
27692f8b c0c9cb78 00000000

<4>[   67.791024] 2eb0  00000000 81240002 000001e5 00000000 5f6d736d 
5f6d6163 76726573 302e7265

<4>[   67.799185]

<4>[   67.799187] R1: 0xdb938550:

<4>[   67.803439] 8550  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000

<4>[   67.811598] 8570  00000000 00000000 00000000 00000000 65646976 
696c346f 0078756e 00000000

<4>[   67.819758] 8590  00000000 00000000 00000000 00000000 00000000 
00000000 00800000 00000000

<4>[   67.827916] 85b0  00000000 00000000 00000000 00000000 00000009 
00000000 dbea2e00 db938580

<4>[   67.836076] 85d0  dbea2e50 00000000 00000000 00000000 00000000 
79ac7656 db938500 00000006

<4>[   67.844236] 85f0  db1b3390 41ed0001 00004a0e 00000000 65646976 
3030316f 00000000 00000000

<4>[   67.852395] 8610  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000

<4>[   67.860557] 8630  00000000 00000000 00000000 00000000 0000000c 
00000000 db9385c0 db938600

<4>[   67.868716]

<4>[   67.868718] R2: 0xefd3d710:

<4>[   67.872970] d710  ******** ******** ******** ******** ******** 
******** ******** ********

<4>[   67.881129] d730  ******** ******** ******** ******** ******** 
******** ******** ********

<4>[   67.889289] d750  ******** ******** ******** ******** ******** 
******** ******** ********

<4>[   67.897448] d770  ******** ******** ******** ******** ******** 
******** ******** ********


I am using kernel 3.4.0. Steps to re-produce
->cd /sys/devices/platform/
->ls -l -R *

Any clues for debugging ?

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


