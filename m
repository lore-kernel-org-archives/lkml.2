Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1ECUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:03:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25782 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab1ECUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:03:35 -0400
Subject: [PATCH 00/16] cciss: May 3, 2011 updates
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:52:48 -0500
Message-ID: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series mostly contains fixes to improve kdump behavior
and esp. to make older controllers which cannot be hard reset work by
doing a soft reset instead.   There are a few patches factoring out
various functionality into individual functions make way for the soft
reset functionality.  There is also a bugfix which prevents PCI write
combining from potentially causing commands to get lost. 

---

Stephen M. Cameron (16):
      cciss: add readl after writel in interrupt mask setting code
      cciss: do a better job of detecting controller reset failure
      cciss: factor out command pool allocation functions
      cciss: factor out scatterlist allocation functions
      cciss: factor out irq request code
      cciss: fix reply pool and block fetch table memory leaks
      cciss: get rid of message related magic numbers
      cciss: increase time to wait for board reset to start
      cciss: clarify messages around reset behavior
      cciss: increase timeouts for post-reset no-ops
      cciss: use new doorbell-bit-5 reset method
      cciss: do soft reset if hard reset is broken
      cciss: remove superfluous sleeps around reset code
      cciss: do not attempt PCI power management reset method if we know it won't work.
      cciss: do not use bit 2 doorbell reset
      cciss: add cciss_tape_cmds module paramter


 Documentation/blockdev/cciss.txt |   15 +
 drivers/block/cciss.c            |  571 ++++++++++++++++++++++++++++++--------
 drivers/block/cciss.h            |   11 +
 drivers/block/cciss_cmd.h        |   11 +
 drivers/block/cciss_scsi.c       |   41 ++-
 drivers/block/cciss_scsi.h       |    4 
 6 files changed, 515 insertions(+), 138 deletions(-)

-- 
-- steve

