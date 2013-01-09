Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3AIG1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:27:34 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11136 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3AIG1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:27:32 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gleb Natapov <gleb@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] AER-KVM: Error containment of VFIO devices assigned to
 KVM guests
Thread-Topic: [PATCH 0/2] AER-KVM: Error containment of VFIO devices
 assigned to KVM guests
Thread-Index: Ac3tvYsmGHLuaf/QR6ONBIGyKve/2wAcvAww
Date: Wed, 9 Jan 2013 06:26:09 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90149602A@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for error containment when a VFIO device assigned to a KVM
guest encounters an error. This is for PCIe devices/drivers that support AER
functionality. When the host OS is notified of an error in a device either
through the firmware first approach or through an interrupt handled by the AER
root port driver, the error handler registered by the vfio-pci driver gets
invoked. The qemu process is signaled through an eventfd registered per
VFIO device by the qemu process. In the eventfd handler, qemu decides on
what action to take. In this implementation, guest is brought down to
contain the error.

---
Vijay Mohan Pandarathil(2):

[PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting AER
[PATCH 2/2] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices

Kernel files changed

 drivers/vfio/pci/vfio_pci.c         | 29 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 drivers/vfio/vfio.c                 |  8 ++++++++
 include/linux/vfio.h                |  1 +
 include/uapi/linux/vfio.h           |  9 +++++++++
 5 files changed, 48 insertions(+)

Qemu files changed

 hw/vfio_pci.c              | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |  9 ++++++++
 2 files changed, 65 insertions(+)
