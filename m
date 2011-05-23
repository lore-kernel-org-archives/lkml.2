Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1EWAif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:38:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23028 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1EWAib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:38:31 -0400
Date: Sun, 22 May 2011 17:38:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mike Waychison <mikew@google.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh <greg@kroah.com>
Subject: [PATCH -next] firmware: fix GOOGLE_SMI kconfig dependency warning
Message-Id: <20110522173802.c0766c64.randy.dunlap@oracle.com>
In-Reply-To: <20110520165507.cba539d5.sfr@canb.auug.org.au>
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DD9AC80.00E3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Is it meaningful/useful to enable EFI_VARS but not EFI?
That's what GOOGLE_SMI does.  Make it enable EFI also.

Fixes this kconfig dependency warning:

warning: (GOOGLE_SMI) selects EFI_VARS which has unmet direct dependencies (EFI)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Waychison <mikew@google.com>
---
 drivers/firmware/google/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110520.orig/drivers/firmware/google/Kconfig
+++ linux-next-20110520/drivers/firmware/google/Kconfig
@@ -13,6 +13,7 @@ menu "Google Firmware Drivers"
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
 	depends on ACPI && DMI
+	select EFI
 	select EFI_VARS
 	help
 	  Say Y here if you want to enable SMI callbacks for Google
