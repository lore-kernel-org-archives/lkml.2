Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1C2Cth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 22:49:37 -0400
Received: from mx3.twosigma.com ([208.77.213.34]:56697 "EHLO mx3.twosigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab1C2Ctg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 22:49:36 -0400
From: Sean Noonan <Sean.Noonan@twosigma.com>
To: "'Dave Chinner'" <david@fromorbit.com>
CC: "'Michel Lespinasse'" <walken@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Mon, 28 Mar 2011 22:49:33 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Thread-Topic: XFS memory allocation deadlock in 2.6.38
Thread-Index: Acvts9zxn6JLCEvNSyWF52bVA/QwTAAB691A
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B534F@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <20110329015137.GD3008@dastard>
In-Reply-To: <20110329015137.GD3008@dastard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As it is, the question I'd really like answered is how a machine with
> 48GB RAM can possibly be short of memory when running mmap() on a
> 16GB file.  The error that XFS is throwing indicates that the
> machine cannot allocate a single page of memory, so where has all
> your memory gone, and why hasn't the OOM killer been let off the
> leash?  What is consuming the other 32GB of RAM or preventing it
> from being allocated? 
Here's meminfo while a test was deadlocking.  As you can see, we certainly aren't running out of RAM.
# cat /proc/meminfo 
MemTotal:       49551548 kB
MemFree:        44139876 kB
Buffers:            5324 kB
Cached:          4970552 kB
SwapCached:            0 kB
Active:            52772 kB
Inactive:        4960624 kB
Active(anon):      37864 kB
Inactive(anon):        0 kB
Active(file):      14908 kB
Inactive(file):  4960624 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:           4914084 kB
Writeback:             0 kB
AnonPages:         37636 kB
Mapped:          4925460 kB
Shmem:               280 kB
Slab:             223212 kB
SReclaimable:     176280 kB
SUnreclaim:        46932 kB
KernelStack:        3968 kB
PageTables:        35228 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    47073968 kB
Committed_AS:      86556 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      380892 kB
VmallocChunk:   34331773836 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        2048 kB
DirectMap2M:     2086912 kB
DirectMap1G:    48234496 kB


> Perhaps the output of xfs_bmap -vvp <file> after a successful vs
deadlocked run would be instructive....

I will try to get this tomorrow.

Sean
