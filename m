Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2CUXls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:41:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40818 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2CUXlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:41:47 -0400
MIME-Version: 1.0
Message-ID: <cb50b439-1e5f-443e-9369-4f7c989d3565@default>
Date: Wed, 21 Mar 2012 16:30:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>,
        Akshay Karle <akshay.a.karle@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: zcache preliminary benchmark results
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F6A6733.001C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last November, in an LKML thread I would rather forget*, James
Bottomley and others asked for some benchmarking to be done for
zcache (among other things).  For various reasons, that benchmarking
is just now getting underway and more will be done, but it might be
useful to publish some interesting preliminary results now.

Summary: On a kernel compile "make -jN" workload, with different
values of N to test varying memory pressure, zcache
shows no performance loss when memory pressure is low,
and up to 31% performance improvement when memory pressure
is moderate to high.  RAMster does even better.

(Note that RAM is intentionally constrained to 1GB to force
memory pressure for higher N in the workload.)

* thread summarized in LWN (http://lwn.net/Articles/465317/)

=========

Benchmark results and description:

(all results in seconds so smaller is better)
N=	nozcache	zcache	faster by	RAMster	faster by
4	879		877		0%		887		-1%
8	858		856		0%		866		-1%
12	858		856		0%		875		-2%
16	1009		922		9%		949		6%
20	1316		1154		14%		1162		13%
24	2164		1714		26%		1788		21%
28	3293		2500		31%		2177		51%
32	4286		4282		0%		3599		19%
36	6516		6602		-1%		5394		22%
40	DNC		13755				8172		68% (over zcache)

DNC=did not complete: stopped after 5 hours = 18000

Workload:
	kernel compile "make -jN" with varying N
	measurements in elapsed seconds
	boot kernel: 3.2 + frontswap/ramster commits
	Oracle Linux 6 distro with ext4
	fresh reboot for each test run
	all tests run as root in multi-user mode

Hardware:
	Dell Optiplex 790 = ~$500 (two used for RAMster)
	Intel Core i5-2400 @ 3.10 GHz, 4coreX2thread, 6M cache
	1GB RAM DDR3 1333Mhz (for RAMster, other server has 8GB)
	One 7200rpm SATA 6.0Gb/s drive with 8MB cache
	10GB swap partition
