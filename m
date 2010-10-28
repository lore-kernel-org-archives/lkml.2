Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0J1HRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:17:46 -0400
Received: from rrzmta1.rz.uni-regensburg.de ([194.94.155.51]:44738 "EHLO
	rrzmta1.rz.uni-regensburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758011Ab0J1HRp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:17:45 -0400
Message-Id: <4CC93FB3020000A100010B20@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 28 Oct 2010 09:17:39 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Q: kernel log not serialized (SLES10 SP3)?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just found some "interesting" kernel boot messages from a two Dual-Core Opteron machine (SunFire X4100) running SLES10 SP3 (2.6.16.60-0.54.5-xen):
<6>Security Framework v1.0.0 initialized
<4>Mount-cache hash table entries: 256
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<6>checking if image is initramfs... it is
<4>Freeing initrd memory: 8553k freed
<4>Initializing CPU#1
<4>Initializing CPU#2
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<6>Brought up 4 CPUs
<4>Initializing CPU#3
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 1024K (64 bytes/line)
<4>migration_cost=523
<6>NET: Registered protocol family 16

The entries seem to be out of order, specifically initializing a CPU after "Brought up 4 CPUs". If the race is intended that way, I'd add the CPU number to the lines that print cache information.

And on "migration cost": It seems to be a penalty for a vector leading from on CPU to another, most likely in a symmetrical fashion. On a NUMA architecture like the Opteron the CPUs could be added to the message. Sample:
CPU1-CPU2: migration cost=523

Regards,
Ulrich
P.S.:Please keep CC: as I'm not subscribed.


