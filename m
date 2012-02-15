Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab2BOOzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:55:46 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42120 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2BOOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:50:47 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de
Subject: [PATCH v2 00/11] firewire-sbp-target: FireWire SBP-2 SCSI target
Date: Wed, 15 Feb 2012 14:47:17 +0000
Message-Id: <1329317248-94128-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1328989452-20921-1-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
as a SCSI transport. This module uses the SCSI Target framework to
expose LUNs to other machines attached to a FireWire bus, in effect
acting as a FireWire hard disk similar to FireWire Target Disk mode on
many Apple computers.

Changes since v1:
* Fixed some copy & paste issues
* Updated Kconfig (wording, depends, 'default n')
* Removed some unnecessary EXPORT_SYMBOL()s
* Merged sbp_util.{c,h} into sbp_configfs.c and sbp_base.h
* Merged sbp_proto.{c,h} into sbp_fabric.{c,h}
* Cleaned up comments and several printks
* Fixed a few minor bugs
* Create & use our own workqueue instead of using fw_workqueue
* Dropped the unused TFO->new_cmd_map and sbp_new_cmd()
* Overhauled and simplified tgt_agent_fetch_work()
* Removed some redundant members of struct sbp_target_request
* Removed struct sbp_lun and code to maintain redundant LUN list
* Added spinlock to struct sbp_session and use locking throughout
* Moved fw_card_{get,put,release}() into linux/firewire.h

It didn't feel like a lot of changes but actually that's quite a lot of work,
looking back at it...

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net.

