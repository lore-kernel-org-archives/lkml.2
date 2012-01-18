Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2AROjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:39:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:33423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab2AROjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:39:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99981259"
Date: Wed, 18 Jan 2012 09:39:44 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] NVM Express driver
Message-ID: <20120118143944.GA14291@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please can you pull the NVM Express driver?

The only code touched outside the driver is adding an EXPORT_SYMBOL for
xen_biovec_phys_mergeable which was approved by Jens here:
https://lkml.org/lkml/2011/9/21/185

The following changes since commit ccb19d263fd1c9e34948e2158c53eacbff369344:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-01-17 22:26:41 -0800)

are available in the git repository at:

  git://git.infradead.org/users/willy/linux-nvme.git master

Krzysztof Wierzbicki (1):
      NVMe: Update admin opcodes to match the 1.0RC spec

Matthew Wilcox (99):
      Xen: Export xen_biovec_phys_mergeable
      NVMe: New driver
      NVMe: Factor out queue_request_irq()
      NVMe: Reduce set_queue_count arguments by one
      NVMe: Implement per-CPU queues
      NVMe: Rename 'cycle' to 'phase'
      NVMe: Fix admin IRQ claim on real hardware
      NVMe: Use PRP2 for the nvme_identify ioctl
      NVMe: Make nvme_common_command more featureful
      NVMe: Add nvme_setup_prps()
      NVMe: Zero the command before we send it
      NVMe: Change NVME_IOCTL_GET_RANGE_TYPE to return all the ranges
      NVMe: Create nvme_map_user_pages() and nvme_unmap_user_pages()
      NVMe: Add NVME_IOCTL_SUBMIT_IO
      NVMe: Read the model, serial & firmware rev from the controller
      NVMe: Remove 'node' from nvme_dev
      NVMe: Check returns from nvme_alloc_queue()
      NVMe: Enable device DMA
      NVMe: Allow queues to be allocated above 4GB
      NVMe: Request I/O regions
      NVMe: Move sysfs entries to the right place
      NVMe: Add remaining status codes
      NVMe: Add download / activate firmware ioctls
      NVMe: Release 0.2
      NVMe: Allow fatal signals to interrupt I/O
      NVMe: Call put_nvmeq() before calling nvme_submit_sync_cmd()
      NVMe: Add a module parameter to use a threaded interrupt
      NVMe: Use a symbolic name to represent cancelled commands instead of 0
      NVMe: Detect commands that are completed twice
      NVMe: Detect command IDs completing that are out of range
      NVMe: Need to lock queue during interrupt handling
      NVMe: Record the timeout for each command
      NVMe: Handle the congestion list a little better
      NVMe: Renumber the special context values
      NVMe: Advance the sg pointer when filling in an sg list
      NVMe: Rename nvme_req_info to nvme_bio
      NVMe: Switch to use DMA Pool API
      NVMe: Optimise memory usage for I/Os between 4k and 128k
      NVMe: Pass the nvme_dev to nvme_free_prps and nvme_setup_prps
      NVMe: Check for DMA mapping failure
      NVMe: Handle physical merging of bvec entries
      NVMe: Update BAR structure to match the current spec
      NVMe: Handle failures differently in nvme_submit_bio_queue()
      NVMe: Add a kthread to handle the congestion list
      NVMe: Release 0.3
      NVMe: Remove setting of 'flags' in rw command
      NVMe: Rename nr_queues to nr_io_queues
      NVMe: Let the kthread take care of devices earlier
      NVMe: Correct SQ doorbell semantics
      NVMe: Mark CMD_CTX_CANCELLED as being unlikely
      NVMe: Implement Flush
      NVMe: Handle bios that contain non-virtually contiguous addresses
      NVMe: Fix discontiguous accesses
      NVMe: Reduce maximum queue depth by 1
      NVMe: Version 0.4
      NVMe: Convert comments to kernel-doc notation
      NVMe: Fix comment formatting
      NVMe: Remove outdated comments
      NVMe: Fix interpretation of 'Number of Namespaces' field
      NVMe: Fix off-by-one when filling in PRP lists
      NVMe: Remove the kthread from the wait queue
      NVMe: Simplify queue lookup
      NVMe: Add compat_ioctl
      NVMe: Correct the definitions of two ioctls
      NVMe: Change the definition of nvme_user_io
      NVMe: Version 0.5
      NVMe: Correct the Controller Configuration settings
      NVMe: Fix warning in free_irq
      NVMe: Time out initialisation after a few seconds
      NVMe: Fix bug in error handling
      NVMe: Rename cancel_cmdid_data to cancel_cmdid
      NVMe: Add support for timing out I/Os
      NVMe: Add include of delay.h for msleep
      NVMe: Use an IDA to allocate minor numbers
      NVMe: Handle failures from memory allocations in nvme_setup_prps
      NVMe: Add a few calling convention notes
      NVMe: Version 0.6
      NVMe: Return real error from nvme_create_queue
      NVMe: Add the nvme thread to the wait queue before waking it up
      NVMe: Rework ioctls
      Fix bug in NVME_IOCTL_SUBMIT_IO
      NVMe: Correct sg list setup in nvme_map_user_pages
      NVMe: Fix memory leak in nvme_dev_add()
      NVMe: Create nvme_identify and nvme_get_features functions
      NVMe: Don't probe namespace 0
      NVMe: Version 0.7
      NVMe: Implement doorbell stride capability
      NVMe: Update Identify Controller data structure
      NVMe: Simplify completion handling
      NVMe: Change get_nvmeq to take a dev instead of a namespace
      NVMe: Change nvme_completion_fn to take a dev
      NVMe: Merge the nvme_bio and nvme_prp data structures
      NVMe: Rename IO_TIMEOUT to NVME_IO_TIMEOUT
      NVMe: Fix DMA mapping for admin commands
      NVMe: Mark the end of the sg list
      NVMe: Simplify nvme_unmap_user_pages
      NVMe: Set queue flags correctly
      NVMe: Version 0.8
      NVMe: Set number of queues correctly

Nisheeth Bhat (2):
      NVMe: Fix calls to dma_unmap_sg
      Fix calculation of number of pages in a PRP List

Shane Michael Matthews (3):
      NVMe: Enable and disable the PCI device
      NVMe: Disable the device before we write the admin queues
      NVMe: Initial PRP List support

 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/block/Kconfig                |   11 +
 drivers/block/Makefile               |    1 +
 drivers/block/nvme.c                 | 1745 ++++++++++++++++++++++++++++++++++
 drivers/xen/biomerge.c               |    1 +
 include/linux/nvme.h                 |  434 +++++++++
 6 files changed, 2193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/nvme.c
 create mode 100644 include/linux/nvme.h
