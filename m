Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1AFDaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:30:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:3908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab1AFDaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:30:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,281,1291622400"; 
   d="scan'208";a="370721399"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com
Cc: arjan@linux.intel.com, trenn@suse.de, kent.liu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 0/2] apic: Fix error interrupt report at all APs 
Date: Thu,  6 Jan 2011 11:28:50 +0800
Message-Id: <1294284532-24285-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, customer report that once machine boot, there are many error interrupt
reported with exact number of all APs. 

The root cause is Local APIC will generate error interrupt when it detect
the illegal vector (one in 0 ~ 15) in an interrupt message received or
interrupt generate from local vector table or self IPI. SDM3A.chapter 10.

The thermal sensor register will be reset to 0x10000, current thermal throttling
driver will first restore AP with the thermal sensor register value of geting
from BSP,but BSP thermal sensor register is also set 0x10000.  value 0x10000
means the interrupt vector is zero. After writing 0x10000 to thermal sensor LVT,
the processor will recieve the error interrupt report if the APIC error
interrupt is also set.

Restore thermal sensor value of BSP is useless because it will soon be set to
correct value included legal vector information.  This patch remove the restore
process. So the agony noise of error interrupt will dismiss when machine boot.  

In patchset also add print out error interrupt detail debug information. 


