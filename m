Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0FVNys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:54:48 -0400
Received: from reaktio.net ([194.89.68.22]:56850 "EHLO ydin.reaktio.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab0FVNyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:54:47 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 09:54:46 EDT
Date: Tue, 22 Jun 2010 16:44:10 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: open-iscsi@googlegroups.com
Subject: Linux IO scalability and pushing over million IOPS over software
	iSCSI?
Message-ID: <20100622134410.GT17817@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently Intel and Microsoft demonstrated pushing over 1.25 million IOPS using software iSCSI and a single 10 Gbit NIC:
http://communities.intel.com/community/wired/blog/2010/04/22/1-million-iops-how-about-125-million

Earlier they achieved one (1.0) million IOPS:
http://blog.fosketts.net/2010/01/14/microsoft-intel-push-million-iscsi-iops/
http://communities.intel.com/community/openportit/server/blog/2010/01/19/1000000-iops-with-iscsi--thats-not-a-typo

The benchmark setup explained:
http://communities.intel.com/community/wired/blog/2010/04/20/1-million-iop-article-explained
http://dlbmodigital.microsoft.com/ppt/TN-100114-JSchwartz_SMorgan_JPlawner-1032432956-FINAL.pdf


So the question is.. does someone have enough new hardware to try this with Linux?
Can Linux scale to over 1 million IO operations per second?


Intel and Microsoft used the following for the benchmark:

	- Single Windows 2008 R2 system with Intel Xeon 5600 series CPU, 
	  single-port Intel 82599 10 Gbit NIC and MS software-iSCSI initiator 
	  connecting to 50x iSCSI LUNs.
	- IOmeter to benchmark all the 50x iSCSI LUNs concurrently.

	- 10 servers as iSCSI targets, each having 5x ramdisk LUNs, total of 50x ramdisk LUNs.
	- iSCSI target server also used 10 Gbit NICs, and StarWind iSCSI target software.
	- Cisco 10 Gbit switch (Nexus) connecting the servers.

	- For the 1.25 million IOPS result they used 512 bytes/IO benchmark, outstanding IOs=20.
	- No jumbo frames, just the standard MTU=1500.

They used many LUNs so they can scale the iSCSI connections to multiple CPU cores 
using RSS (Receive Side Scaling) and MSI-X interrupts. 

So.. Who wants to try this? :) I don't unfortunately have 11x extra computers with 10 Gbit NICs atm to try it myself..

This test covers networking, block layer, and software iSCSI initiator..
so it would be a nice to see if we find any bottlenecks from current Linux kernel.

Comments please!

-- Pasi

