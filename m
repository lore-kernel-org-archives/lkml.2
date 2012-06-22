Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511Ab2FVHZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:25:32 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:39512 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761430Ab2FVHZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:25:31 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 03:25:31 EDT
Message-Id: <4FE43784020000A100009FB0@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 09:14:44 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: FYI: Problem in current SLES11 SP1 Kernel (2.6.32.59-0.3) with
 rr-bonding
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just wanted to let you know that we see a problem since we upgraded to SLES 11 SP1 kernel 2.6.32.59-0.3 on x86_64:

The machines have several NICs using "Broadcom NetXtreme II BCM5706/5708/5709/5716 Driver" 2.0.4. Two of the NICs are used for a round-robin bond with ARP monitoring.

The new problem is that after boot the bond master and slaves all seem up, packets go in and out, but no ping works.

Only after I remove and re-add the slaves (one after the other), ping works. Once it works, it continues to work:

# echo -eth2 > /sys/class/net/bond1/bonding/slaves
##wait a bit
# echo +eth2 > /sys/class/net/bond1/bonding/slaves
##wait a bit
# echo -eth3 > /sys/class/net/bond1/bonding/slaves
##wait a bit
# echo +eth3 > /sys/class/net/bond1/bonding/slaves
##wait a bit


Before the kernel update, bonding worked. Unfortunately we don't boot that frequently, so I'm not sure whether it worked all the time.

I also had made another test with two machines and a four-NIC-rr-bond that featured "direct-connect cables" with SLES11 SP2 (kernel 3.2.x).  Here also I had seen unreliable initialization. However after a kernel update, the problem was gone.

For SLES, I suspect that patches around this to cause theproblem (haven't looked into the actual source yet):
- patches.fixes/bonding-start-slaves-with-link-down-for-ARP-monitor.patch:
  bonding: start slaves with link down for ARP monitor
  (bnc#752634).

Regards,
Ulrich


