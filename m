Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1BVUOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:15 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5698 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1BVUON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:13 -0500
Subject: [PATCH 0/6] cciss: Feb 22, 2010 updates 
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 22 Feb 2011 14:14:11 -0600
Message-ID: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements mostly minor fixes.
Hoisted a tag masking operation out of a loop.  Inform
the controller that we're using 32-bit tags.  Mask off
low error bits prior to calling pci_free_consistent.
Removed an unnecessary cast of kmalloc return value.
Fixed a missing command status of CMD_UNABORTABLE.
Added cciss_tape_cmds module parameter to allow reserving
more commands for use with SCSI tape drives.

---

Stephen M. Cameron (6):
      cciss: host tag masking out of loop
      cciss: Inform controller we are using 32-bit tags.
      cciss: Mask off error bits of c->busaddr in cmd_special_free when calling pci_free_consistent
      cciss: remove unnecessary casts
      cciss: fix missed command status value CMD_UNABORTABLE
      cciss: add cciss_tape_cmds module paramter


 Documentation/blockdev/cciss.txt |   16 ++++++++++
 drivers/block/cciss.c            |   58 ++++++++++++++++++++++++++------------
 drivers/block/cciss_cmd.h        |    1 +
 drivers/block/cciss_scsi.c       |   45 +++++++++++++++++------------
 drivers/block/cciss_scsi.h       |    4 ---
 5 files changed, 83 insertions(+), 41 deletions(-)

-- 
-- steve
