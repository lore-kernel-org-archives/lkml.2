Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2ICAEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:04:22 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:46670 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755324Ab2ICADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:03:39 -0400
Subject: [PATCH 3/5] PCI: hotplug: remove acpi_bus_generate_proc_event
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Bjorn Helgaas <bhelgaas@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 02:03:27 +0200
Message-ID: <1346630607.3170.31.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling this function no longer makes sense as /proc/acpi/event
is being removed.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/pci/hotplug/acpiphp_ibm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index c35e8ad..5394fff 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -270,7 +270,6 @@ static void ibm_handle_events(acpi_handle handle, u32 event, void *context)
 
 	if (subevent == 0x80) {
 		dbg("%s: generationg bus event\n", __func__);
-		acpi_bus_generate_proc_event(note->device, note->event, detail);
 		acpi_bus_generate_netlink_event(note->device->pnp.device_class,
 						  dev_name(&note->device->dev),
 						  note->event, detail);
-- 
1.7.4.1




