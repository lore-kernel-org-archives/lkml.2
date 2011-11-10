Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1KJAnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:43:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651Ab1KJAnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:43:41 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/3] PCI: Convert maintaining FW-assigned BIOS BAR values to a
	list of temporary entries
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Nov 2011 17:43:39 -0700
Message-ID: <20111110004339.5866.28478.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 58c84eda075 functionality was introduced that tries to reinstate
the original, FW-assigned, BAR addresses of a PCI device when normal
resource assignment attempts fail.  To keep track of the BIOS BAR
addresses, struct pci_dev was augmented with an array to hold the BAR
addresses of the PCI device: 'resource_size_t
fw_addr[DEVICE_COUNT_RESOURCE]'.

The reinstatement of BAR addresses is an uncommon event leaving the
'fw_addr' array unused normally.  As the use of struct pci_dev is so
prevalent, this seems wasteful.

This patch series introduces a stand alone data structure and
corresponding set of interfacing routines, converting the underlying
aspects of the existing maintanence scheme to a list of temporary BIOS
BAR value entries instead.

---

Myron Stowe (3):
      x86/PCI: Convert maintaining FW-assigned BIOS BAR values to use a list
      PCI: Maintain a list of FW-assigned BIOS BAR values
      PCI: Fix starting basis for resource requests


 arch/x86/pci/i386.c     |    2 -
 drivers/pci/setup-res.c |  100 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/pci.h     |    2 -
 3 files changed, 92 insertions(+), 12 deletions(-)

-- 
