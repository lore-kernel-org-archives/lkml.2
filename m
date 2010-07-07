Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0GGSeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:34:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58088 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0GGSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vvfJIue1TupcXEPDaZWAKHx0FDUPAFeHDX3x1RaElfdvVrZH1saNR+ueB3wlORLJa1
         Koj8HTNJjumjGem4TnSOKiK5EvZlJETUXOy11g3eiK9m2k4NAYjfn8WTLcMNijAS5Xvl
         5a+eZOBUcif6tbz4WmZd+ZP2gd5rgyKFFWODA=
Date: Wed, 7 Jul 2010 19:30:15 +0100
From: Luis Henriques <luis.henrix@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ACPI: fan: Fix more unbalanced code block
Message-ID: <20100707183015.GA27757@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 934231de706d2579fae14f5857fcd8de991009ff fixes an unbalanced
CONFIG_ACPI_PROCFS code block during module initialisation.  This
patch fixes similar issue but for the module exit.

Signed-off-by: Luis Henriques <luis.henrix@gmail.com>
---
 drivers/acpi/fan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 8a3b840..d94d295 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -369,7 +369,9 @@ static void __exit acpi_fan_exit(void)
 
 	acpi_bus_unregister_driver(&acpi_fan_driver);
 
+#ifdef CONFIG_ACPI_PROCFS
 	remove_proc_entry(ACPI_FAN_CLASS, acpi_root_dir);
+#endif
 
 	return;
 }
-- 
1.7.1

