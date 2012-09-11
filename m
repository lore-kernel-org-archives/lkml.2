Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2IKLjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:39:11 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:26724 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab2IKLek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AscCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4JKDwE0EjUCJgJfCogdqGiTN4EhjwOBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505277"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 00/20] ipack: added callbacks and some cleanup
Date: Tue, 11 Sep 2012 13:34:53 +0200
Message-Id: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This second version adds Dan Carpenter's suggestions and it has been rebased
from gregkh's staging-next repository.

Dan, if you want, you can add the Reviewed-by for all the patches again.

Hopefully, this time the MTA will not change the Content-Transfer-Encoding from
8bit to base64.

Thanks,

Sam

Jens Taprogge (10):
  Staging: ipack/bridges/tpci200: Put the TPCI200 control registers
    into a struct.
  Staging: ipack: Provide several carrier callbacks.
  Staging: ipack/bridges/tpci200: provide new callbacks to tpci200
  Staging: ipack: Obtain supported speeds from ID ROM.
  Staging: ipack: Choose the optimum bus speed by default.
  Staging: ipack: remove field driver from struct ipack_device.
  Staging: ipack: Switch to 8MHz operation before reading ID.
  Staging: ipack: reset previous timeouts during device registration.
  Staging: ipack: check the device ID space CRC.
  Staging: ipack/bridges/tpci200: Store the irq holder in slot_irq.

Samuel Iglesias Gonsálvez (10):
  Staging: ipack/bridges/tpci200: remove struct list_head
  Staging: ipack/bridges/tpci200: reorder the iounmap and
    pci_release_region
  Staging: ipack/bridges/tpci200: increment the reference counter of
    the pci_dev
  Staging: ipack/bridges/tpci200: fix the uninstall the ipack device
  Staging: ipack/devices/ipoctal: change exiting procedure
  Staging: ipack/devices/ipoctal: free the IRQ.
  Staging: ipack: unregister devices when uninstall the carrier device.
  Staging: ipack/bridges/tpci200: delete ipack_device_unregister calls
    when     exiting
  Staging: ipack/bridges/tpci200: remove tpci200_slot_unregister
  Staging: ipack: delete .remove_device() callback

 drivers/staging/ipack/bridges/tpci200.c |  189 +++++++++++++++++++++----------
 drivers/staging/ipack/bridges/tpci200.h |   24 ++--
 drivers/staging/ipack/devices/ipoctal.c |    7 +-
 drivers/staging/ipack/ipack.c           |  104 +++++++++++++++--
 drivers/staging/ipack/ipack.h           |   21 +++-
 5 files changed, 256 insertions(+), 89 deletions(-)

-- 
1.7.10.4

