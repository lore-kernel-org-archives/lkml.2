Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab0GSSjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:39:12 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11268 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936475Ab0GSSjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:39:09 -0400
Subject: [PATCH 00/26] cciss updates July 19, 2010 
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:44:39 -0500
Message-ID: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements mostly cleanups to the initialization
code in cciss along the same lines as what's already been done in hpsa.

There are also a few bug fixes.  The SCSI tape code was not setting the
performant mode bits in commands, which caused a hang.  The code to
reset controllers via PCI power management methods only works on old
controllers, so an alternate method is used for newer controllers.

There are a couple of big patches to make cciss use more consistent
variable names (always h for hba, and c for command, rather than a
mishmash of various things names) and to generally use dev_warn, etc.
instead of printk.

These patches apply to the 'for-2.6.36' branch of Jens Axboe's git
tree: http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
(there are many changes to cciss in that tree on which these patches depend.)

---

Stephen M. Cameron (26):
      cciss: Set the performant mode bit in the scsi half of the driver
      cciss: save pdev pointer in per hba structure early to avoid passing it around so much.
      cciss: factor out cciss_lookup_board_id
      cciss: factor out cciss_board_disabled
      cciss: remove board_id parameter from cciss_interrupt_mode()
      cciss: factor out cciss_find_memory_BAR()
      cciss: factor out cciss_wait_for_board_ready()
      cciss: factor out cciss_find_cfgtables
      cciss: fix leak of ioremapped memory
      cciss: factor out cciss_find_board_params
      cciss: factor out CISS_signature_present()
      cciss: factor out cciss_enable_scsi_prefetch()
      cciss: factor out cciss_p600_dma_prefetch_quirk()
      cciss: cleanup some debug ifdefs
      cciss: make cciss_put_controller_into_performant_mode as __devinit
      cciss: factor out cciss_wait_for_mode_change_ack()
      cciss: factor out cciss_enter_performant_mode
      cciss: factor out cciss_find_cfg_addrs.
      cciss: factor out cciss_reset_devices()
      cciss: fix hard reset code.
      cciss: sanitize max commands
      cciss: forbid hard reset of 640x boards
      cciss: use consistent variable names
      cciss: separate cmd_alloc() and cmd_special_alloc()
      cciss: change printks to dev_warn, etc.
      cciss: cleanup interrupt_not_for_us


 drivers/block/cciss.c      | 1728 ++++++++++++++++++++++++--------------------
 drivers/block/cciss.h      |   20 -
 drivers/block/cciss_cmd.h  |    4 
 drivers/block/cciss_scsi.c |  666 ++++++++---------
 4 files changed, 1276 insertions(+), 1142 deletions(-)

-- 
-- steve
