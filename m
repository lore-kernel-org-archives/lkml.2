Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2HHGjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:39:14 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:32897 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2HHGjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:39:12 -0400
Message-Id: <502225A9020000A10000B915@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 08 Aug 2012 08:39:05 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Q: diskstats for MD-RAID
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a question based on the SLES11 SP1 kernel (2.6.32.59-0.3-default):
In /proc/diskstats the last four values seem to be zero for md-Devices.

So "%util", "await", and "svctm" from "sar" are always reported as zero.

Ist this a bug or a feature? I'm tracing a fairness problem resulting from an I/O bottleneck similar to that described in kernel bugzilla #12309...

(If the kernel has about 80GB dirty buffers (yes: 80GB), reads using the same I/O channel seem to starve: The scenario is like this: a FC-SAN disksystem with two different types of disks is used to copy from the faster disks to slower disks using "cp". The files are some ten GB in size (Oracle database). After several minutes (while the "cp" is still runing), unrelated processes accessing different disk devices through the same I/O channel suffer from bad response times. I guess the kernel does not know about the relationship of different disk devices being connected through on I/O channel: If the kernel tries to keep each device busy (specifically trying to flush dirty buffers from one disk to make available buffers, it really reduces the I/O rate of other disks. Despite of that, some layers combine 8-sector-requests to something like 600-sector requests, which probably also needs additional buffers and it will hit the response time. The complete I/O stack is: FC-SAN, multipath (RR), MD-RAID1, LVM, ext3)

When replying, please keep me in CC: as I'm not subscribed to the list.

Regards,
Ulrich


