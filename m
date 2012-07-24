Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2GXJjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:39:52 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:21390
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab2GXJjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:39:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7NS62-02-1NH-02
X-M-MSG: 
From: Aaron Lu <aaron.lu@amd.com>
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <minggr@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jeff Wu <jeff.wu@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 0/7] Fix for ZPODD
Date: Tue, 24 Jul 2012 17:37:38 +0800
Message-ID: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
X-Mailer: git-send-email 1.7.11.3
X-OriginalArrivalTime: 24 Jul 2012 09:39:30.0586 (UTC) FILETIME=[398C9FA0:01CD6980]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2:
Bug fix for V1;
Use scsi_autopm_* in sr driver instead of pm_runtime_*;

V1:
Here are some patches to make ZPODD easier to use for end users and
a fix for using ZPODD with system suspend.

Aaron Lu (7):
  scsi: sr: fix for sr suspend and resume
  scsi: pm: use autosuspend if device supports it
  scsi: sr: use scsi layer autopm in sr driver
  scsi: sr: runtime pm when ODD is open/closed
  scsi: sr: block events when runtime suspended
  scsi: pm: use runtime resume callback if available
  block: genhd: add an interface to set disk's poll interval

 block/genhd.c          | 25 ++++++++++++++++------
 drivers/scsi/scsi_pm.c | 22 +++++++++++++------
 drivers/scsi/sr.c      | 57 ++++++++++++++++++++++++++++++++------------------
 include/linux/genhd.h  |  1 +
 4 files changed, 73 insertions(+), 32 deletions(-)

-- 
1.7.11.3


