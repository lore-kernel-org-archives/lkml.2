Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2DPSe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:34:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31230 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2DPSe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:34:26 -0400
MIME-Version: 1.0
Message-ID: <7297ae3b-f3e1-480b-838f-69b0e09a733d@default>
Date: Mon, 16 Apr 2012 11:34:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Followup: [PATCH -mm] make swapin readahead skip over holes
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F8C662F.005C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik --

I saw this patch in 3.4-rc1 (because it caused a minor merge
conflict with frontswap) and wondered about its impact.
Since I had a server still set up from running benchmarks
before LSFMM, I ran my kernel compile -jN workload (with
N varying from 4 to 40) on 1GB of RAM, on 3.4-rc2 both with
and without this patch.

For values of N=24 and N=28, your patch made the workload
run 4-9% percent faster.  For N=16 and N=20, it was 5-10%
slower.  And for N=36 and N=40, it was 30%-40% slower!

Is this expected?  Since the swap "disk" is a partition
on the one active drive, maybe the advantage is lost due
to contention?

Thanks,
Dan

commit removed 67f96aa252e606cdf6c3cf1032952ec207ec0cf0

Workload:
	kernel compile "make -jN" with varying N
	measurements in elapsed seconds
	boot kernel: 3.4-rc2
	Oracle Linux 6 distro with ext4
	fresh reboot for each test run
	all tests run as root in multi-user mode

Hardware:
	Dell Optiplex 790 = ~$500
	Intel Core i5-2400 @ 3.10 GHz, 4coreX2thread, 6M cache
	1GB RAM DDR3 1333Mhz (to force swapping)
	One 7200rpm SATA 6.0Gb/s drive with 8MB cache
	10GB swap partition
