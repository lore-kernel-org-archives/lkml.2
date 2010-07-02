Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0GBHVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:21:04 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64564 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab0GBHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j5Hr5S8GuJtqiK442P+OXU9BL3jD0oBZOvgtqQPZtsQ2L3OF8dKX5CuL2z5wrgbP6I
         txkNnufTR/iFEUGHc1siQ+taWelpjKerVZi4H1rZgQ8UURMl7ny8Upv8KP5NLsj6Nl26
         0w14LFrKdaPB0ihl4kW+YMfGouf9rMubFbOlA=
Subject: [PATCH v2] fujitsu-laptop: remove unnecessary input_free_device
	calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 02 Jul 2010 15:20:48 +0800
Message-Id: <1278055248.12339.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input_free_device should only be used if input_register_device()
was not called yet or if it failed.
This patch removes unnecessary input_free_device calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/fujitsu-laptop.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index e325aeb..4346d26 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -725,6 +725,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_stop:
@@ -738,8 +739,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
@@ -930,6 +929,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_free_fifo:
@@ -953,8 +953,6 @@ static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	kfifo_free(&fujitsu_hotkey->fifo);
 
 	fujitsu_hotkey->acpi_handle = NULL;
-- 
1.5.4.3



