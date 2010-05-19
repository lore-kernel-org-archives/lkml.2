Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0ESAUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0ESAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:20:52 -0400
Message-ID: <4BF32EDE.9080304@redhat.com>
Date: Tue, 18 May 2010 21:20:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Fwd: [GIT PULL for 2.6.35] i7core/Nehalem/Nehalem-EP/Lynnfield/Westmore-EP]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm... I've c/c LMML, instead of LKML... Let's forward the pull request to the
right list... sorry for the mess.

Cheers,
Mauro

-------- Mensagem original --------
Assunto: [GIT PULL for 2.6.35] i7core/Nehalem/Nehalem-EP/Lynnfield/Westmore-EP
Data: Tue, 18 May 2010 21:02:08 -0300
De: Mauro Carvalho Chehab <mchehab@redhat.com>
Para: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm >> Andrew Morton <akpm@linux-foundation.org>,        Linux Edac Mailing List <linux-edac@vger.kernel.org>,        linux Media Mailing List <linux-media@vger.kernel.org>,        bluesmoke-devel@lists.sourceforge.net 	<bluesmoke-devel@lists.sourceforge.net>,        Doug Thompson <dougthompson@xmission.com>

The following changes since commit 66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8:
  Linus Torvalds (1):
        Linux 2.6.34-rc6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/i7core.git linux-next

This patch series adds support for memory error detection for the
Memory Controllers found on the Nehalem CPU's, from i7core to Xeon 56xx,
via EDAC interface.

It doesn't support Xeon 75xx CPU's, as they use a different type of
memory controller.

Cheers,
Mauro


Alan Cox (1):
      edac: i7core_edac produces undefined behaviour on 32bit

Alexander Beregalov (1):
      i7core_edac: fix memory leak of i7core_dev

Aristeu Rozanski (1):
      pci: Add a probing code that seeks for an specific bus

Jiri Slaby (1):
      EDAC: add __init to i7core_xeon_pci_fixup

Keith Mannthey (2):
      i7core_edac: Fix ecc enable shift
      i7core_edac: Probe on Xeons eariler

Mauro Carvalho Chehab (72):
      i7core_edac: Add an EDAC memory controller driver for Nehalem chipsets
      i7core_edac: Add error insertion code for Nehalem
      i7core_edac: Add more status functions to EDAC driver
      i7core_edac: Registers all supported MC functions
      i7core_edac: Show read/write virtual/physical channel association
      i7core_edac: A few fixes at error injection code
      i7core_edac: need mci->edac_check, otherwise module removal doesn't work
      i7core_edac: Add a memory check routine, based on device 3 function 4
      i7core_edac: Add additional tests for error detection
      i7core_edac: Properly fill struct csrow_info
      i7core_edac: Improve error handling
      i7core_edac: Add more information about each active dimm
      i7core_edac: Get more info about the memory DIMMs
      i7core_edac: Memory info fixes and preparation for properly filling cswrow data
      i7core_edac: fill csrows edac sysfs info
      i7core_edac: CodingStyle fixes
      edac_mce: Add an interface driver to report mce errors via edac
      edac/Kconfig: edac_mce can't be module
      i7core_edac: Add edac_mce glue
      i7core_edac: Adds write unlock to MC registers
      i7core_edac: Add a code to probe Xeon 55xx bus
      i7core_edac: add support for more than one MC socket
      i7core_edac: maps all sockets as if ther are one MC controller
      i7core_edac: decode mcelog error and send it via edac interface
      i7core_edac: some fixes at memory error parser
      i7core: fix probing on Xeon55xx
      i7core: check if the memory error is fatal or non-fatal
      i7core: enrich error information based on memory transaction type
      i7core: fix get_devices routine for Xeon55xx
      i7core: better document i7core_get_active_channels()
      i7core: add socket info at the debug msg
      i7core: remove some uneeded noisy debug messages
      i7core_edac: Some cleanups at displayed info
      i7core_edac: some fixes at error injection code
      i7core_edac: fix error codes for sysfs error injection interface
      i7core_edac: fix error injection
      Documentation/edac.txt: Add Nehalem specific EDAC characteristics
      i7core_edac: CodingSyle fixes/cleanups
      i7core_edac: Print an error message if pci register fails
      i7core_edac: Use Device 3 function 2 to report errors with RDIMM's
      i7core: Use registered memories per processor
      i7core_edac: Improve corrected_error_counts output for RDIMM
      i7core: temporary workaround to allow it to compile against 2.6.30
      Dynamically allocate memory for PCI devices
      i7core_edac: create one mc per socket/QPI
      i7core_edac: sanity check: print a warning if a mcelog is ignored
      i7core_edac: a few fixes for multiple mc's
      Documentation/edac.txt: Improve it to reflect the latest changes at the driver
      i7core_edac: Fix a bug when printing error counts with RDIMMs
      i7core_edac: at remove, don't remove all pci devices at once
      i7core_edac: remove static counter for max sockets
      i7core_edac: change remove module strategy
      i7core_edac: We need to use list_for_each_entry_safe to avoid errors
      i7core_edac: Avoid printing a warning when debug is disabled
      edac_core: Allow the creation of sysfs groups
      i7core_edac: Add support for sysfs addrmatch group
      edac: store/show methods for device groups weren't working
      edac: Don't create csrow entries on instance groups
      i7core_edac: Convert UDIMM error counters into a proper sysfs group
      Documentation/edac.txt: Reflect the sysfs changes at the document
      edac: Create an unique instance for each kobj
      i7core_edac: Use a lockless ringbuffer
      i7core_edac: Better parse "any" addrmask
      i7core_edac: First store, then increment
      i7core_edac: Fix ringbuffer maxsize
      i7core_edac: PCI device is called NONCORE, instead of NOCORE
      i7core_edac: Use a more generic approach for probing PCI devices
      i7core_edac: Add initial support for Lynnfield
      i7core: add support for Lynnfield alternate address
      i7core_edac: Fix wrong device id for channel 1 devices
      i7core_edac: Add support for X5670
      i7core_edac: Better describe the supported devices

Randy Dunlap (1):
      edac: fix i7core build

Stephen Rothwell (1):
      i7core_edac: do not export static functions

Tony Luck (1):
      i7core_edac: don't free on success

Vernon Mauery (2):
      Always call i7core_[ur]dimm_check_mc_ecc_err
      Add support for Westmere to i7core_edac driver

 Documentation/edac.txt           |  152 +++
 arch/x86/include/asm/pci_x86.h   |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c |   10 +
 arch/x86/pci/legacy.c            |   42 +-
 drivers/edac/Kconfig             |   13 +
 drivers/edac/Makefile            |    2 +
 drivers/edac/edac_core.h         |   23 +-
 drivers/edac/edac_mc_sysfs.c     |  175 +++-
 drivers/edac/edac_mce.c          |   61 ++
 drivers/edac/i7core_edac.c       | 2078 ++++++++++++++++++++++++++++++++++++++
 include/linux/edac_mce.h         |   31 +
 include/linux/pci.h              |    1 +
 include/linux/pci_ids.h          |   52 +
 13 files changed, 2598 insertions(+), 44 deletions(-)
 create mode 100644 drivers/edac/edac_mce.c
 create mode 100644 drivers/edac/i7core_edac.c
 create mode 100644 include/linux/edac_mce.h
--
To unsubscribe from this list: send the line "unsubscribe linux-edac" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Cheers,
Mauro
