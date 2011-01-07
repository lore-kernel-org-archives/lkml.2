Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1AGGCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:02:38 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:52620 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1AGGCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:02:36 -0500
Date: Fri, 07 Jan 2011 01:02:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 4/5] ACPI / PM: Make suspend_nvs_save() use
 acpi_os_map_memory()
In-reply-to: <alpine.LFD.2.02.1101070045150.20858@x980>
Message-id: <alpine.LFD.2.02.1101070100160.20858@x980>
References: <201101070141.02951.rjw@sisk.pl> <201101070145.58907.rjw@sisk.pl>
 <alpine.LFD.2.02.1101070045150.20858@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> my arrandale laptop took multiple OOPS on resume after this patch.

This bit makes my laptop happy, so I'll add it to this patch.

thanks,
-Len

diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 8e7ab5e..54b6ab8 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -80,7 +80,7 @@ void suspend_nvs_free(void)
 			free_page((unsigned long)entry->data);
 			entry->data = NULL;
 			if (entry->kaddr) {
-				iounmap(entry->kaddr);
+				acpi_os_unmap_memory(entry->kaddr, entry->size);
 				entry->kaddr = NULL;
 			}
 		}


