Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2LAOWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:22:41 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:47958
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2LAOWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:22:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/28] Drivers: hv: Update the Vmbus protocol 
Date: Sat,  1 Dec 2012 06:46:00 -0800
Message-Id: <1354373160-31332-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current vmbus protocol supported in the vmbus driver for Linux is
a version of the protocol that shipped with Windows Server 2008. Since
then a lot of enhancements have been made in the protocol to
specifically address performance and scalability of the communication
infrastructure between the host and the guest.
This patch-set brings our driver to the Win8 (Windows Server 2012) level.
Furthermore, this code will dynamically negotiate the most efficient
protocol that the host can support - the same code can be deployed on all
supported hosts (WS2008, WS2008R2 and WS2012).
Following are some of the key features implemented in this patch-set:
	
	1. More efficient signaling protocol between the host and the guest
	2. Distribution of interrupt load across available CPUs in the guest;
	   currently all vmbus interrupts are delivered to the boot CPU (CPU 0)
	   in the guest.
	3. Per- channel interrupt binding (as part of item 2)
	4. More efficient demultiplexing of incoming interrupts
	5. Per-channel signaling mechanism for host to guest communication


K. Y. Srinivasan (28):
  Drivers: hv: Implement routines for read side signaling optimization
  Drivers: hv: Add state to manage batched reading
  Drivers: hv: Turn off batched reading for util drivers
  Drivers: hv: Optimize signaling in the read path
  Drivers: hv: Optimize the signaling on the write path
  Drivers: hv: Get rid of hv_get_ringbuffer_interrupt_mask()
  Drivers: hv: Support handling multiple VMBUS versions
  Drivers: hv: Update the ring buffer structure to match win8
    functionality
  Drivers: hv: Extend/modify vmbus_channel_offer_channel for win7 and
    beyond
  Drivers: hv: Save and export negotiated vmbus version
  Drivers: hv: Change the signature for hv_signal_event()
  Drivers: hv: Change the signature of vmbus_set_event()
  Drivers: hv: Move vmbus version definitions to hyperv.h
  Drivers: hv: Manage signaling state on a per-connection basis
  Drivers: hv: Cleanup vmbus_set_event() to support win7 and beyond
  Drivers: hv: Setup a mapping for Hyper-V's notion cpu ID
  Drivers: hv: Add state to manage incoming channel interrupt load
  Drivers: hv: Modify the interrupt handling code to support win8 and
    beyond
  Drivers: hv: Add code to distribute channel interrupt load
  Drivers: hv: Get rid of the unused global signaling state
  Drivers: hv: Get rid of unnecessary request for offers
  Drivers: hv: Manage event tasklets on per-cpu basis
  Drivers: hv: Handle vmbus interrupts concurrently on all cpus
  Drivers: hv: Add a check to deal with spurious interrupts
  Drivers: hv: Enable protocol negotiation with win8 hosts
  Drivers: hv: Implement flow management on the send side
  Drivers: hv: Capture the host build information
  Drivers: hv: Cleanup and consolidate reporting of build/version info

 drivers/hv/channel.c      |   31 ++++--
 drivers/hv/channel_mgmt.c |  112 ++++++++++++++++++++++
 drivers/hv/connection.c   |  232 ++++++++++++++++++++++++++++++++-------------
 drivers/hv/hv.c           |   72 +++++++-------
 drivers/hv/hv_util.c      |   10 ++
 drivers/hv/hyperv_vmbus.h |   65 ++++++-------
 drivers/hv/ring_buffer.c  |  130 ++++++++++++++++++++++----
 drivers/hv/vmbus_drv.c    |   54 +++++++++--
 include/linux/hyperv.h    |  154 ++++++++++++++++++++++++++----
 9 files changed, 671 insertions(+), 189 deletions(-)

-- 
1.7.4.1

