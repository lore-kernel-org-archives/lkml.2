Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0KIVrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:47:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34906 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0KIVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JTArHdA/SKui1GBhN+B75I3yHU/jU7c3G2b1kmBPWFtW+U3fGa5P7240al7GQYhOpI
         RcPgKz+OUpsqZaTim0a5LTUkmaVYbXgpo0mser/4dvmVxRIvRUCzupF8EVeq8pfRAkOm
         oiwH9dkuxrfBNU+JO+sDGHSdrEac2JJlKn13k=
Message-ID: <4CD9C4A7.3060603@gmail.com>
Date: Tue, 09 Nov 2010 14:01:11 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 6/6] ce4100: Add support for CE4100 EHCI IP block to EHCI
 driver
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <3b35daeb1bbc42f758e3407a8b28d21dd999c5d9.1289331834.git.dirk.brandewie@gmail.com>
In-Reply-To: <3b35daeb1bbc42f758e3407a8b28d21dd999c5d9.1289331834.git.dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a previous patch in this series GregKH asked that the PCI ID not be added 
to pci_ids.h for ID's that are only used by a single file.  
Here is an updated version of the EHCI controller patch.

Subject: [PATCH] ce4100: Add support for CE4100 EHCI IP block to EHCI driver

This patch adds support for the EHCI IP block present on the Intel
CE4100.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: linux-usb@vger.kernel.org
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-pci.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index a1e8d27..da2b196 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -124,6 +124,10 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			ehci_info(ehci, "disable lpm for langwell/penwell\n");
 			ehci->has_lpm = 0;
 		}
+		if (pdev->device == 0x2e70) {
+			hcd->has_tt = 1;
+			tdi_reset(ehci);
+		}
 		break;
 	case PCI_VENDOR_ID_TDI:
 		if (pdev->device == PCI_DEVICE_ID_TDI_EHCI) {
-- 
1.7.2.3

 
