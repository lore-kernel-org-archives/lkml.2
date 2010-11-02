Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0KBPFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:05:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58928 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0KBPEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EwA5aGFsitBNsV2+SrDbsQgYegguMhd/QBLIAbJrqmQXC+qmz+pwWlGOSlfKYcFOXa
         GdqwwE8hFfOcC09Zuf4+3PDvoyOS1CBw1C3obUUekEbYM8nEXuD/J59YLIgBCLv0rpnO
         5ZlKqXJyH0GMP75HZLrXJYk/pOjT3ntfPnBbM=
Message-ID: <4CD02860.2020103@gmail.com>
Date: Tue, 02 Nov 2010 20:34:00 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: arnaud.patard@rtp-net.org
CC: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device() with
 pci_get_device().
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
recommended in pci.txt filei in PCI Documentation.

Signed-off-by: Atul Sowani <sowani@gmail.com>
---
diff -uprN a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
--- a/drivers/staging/xgifb/XGI_main_26.c	2010-10-21 02:00:22.000000000 +0530
+++ b/drivers/staging/xgifb/XGI_main_26.c	2010-11-01 14:25:21.032436943 +0530
@@ -483,7 +483,7 @@ XGIfb_query_VGA_config_space(struct xgi_
 			break;
 		}

-		pdev = pci_find_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
+		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
 		if (pdev)
 			valid_pdev = 1;
 	}

