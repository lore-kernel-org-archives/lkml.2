Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1BETfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:35:55 -0500
Received: from lucidpixels.com ([75.144.35.66]:48654 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1BETfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:35:53 -0500
Date: Sat, 5 Feb 2011 14:35:52 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Message-ID: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have two identical X8DTH-6's, each with 5520s XEONS..

=== RAID
Two 3ware RAID-0's (testing only) with 24 drives (2TB WD).
Read: 1.2Gbyte/sec
Write: 1.2Gbyte/sec

=== NETWORK
When I run iperf between the two 10GbE interfaces, I get 1.1-1.2Gbyte/sec.
MTU=9000 on both hosts.

== COPY OVER NETWORK
When I copy using cp/NFS, tar/nc, etc.. I only see an average of about 
250MiB/s, I also have two desktop boards (8GB ram/ea) from which I get 
500-550MiB/s from (the raid is slower on the desktop boards, it gets what 
the RAID can read it), how come these server boards cannot push > 1Gbyte/sec
sustained?

I know on this board:
CPU1 => SLOT 1,2,3
CPU2 => SLOT 4,5,6,7

The RAID card is plugged into 2 (CPU1)
The 10GbE card is plugged into 6 (CPU2)

Should both cards be plugged into the same set of slots controlled by the 
same CPU?

Has anyone experienced anything like this before, e.g., > 1Gbyte/sec read 
& write for network and 3ware RAID but when using them in combination, it 
is slow.

OS = CentOS 5.5 x86_64
Filesystem = XFS
NIC = 10GbE AT2 Server Adapter

No single component is < 1Gbyte/sec but when data is transferred from 
hostA to hostB, then it degrades to 250MiB/s.

Justin.

