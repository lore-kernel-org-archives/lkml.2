Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab0CSLoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:44:25 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41794 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0CSLoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iu3Lv22Rt35eI1NimWesc+VucolNXTMsZNwLWoP64u0cRkwE4y9lPOz/uLlZqeFUbB
         oJLJv3ikjPFNsQ+kh08EK1lnMVr0HPaz0ZvB2A7p8wClzyZUzZos79mQAIfPhZV2ZVw2
         fCgw6YMaVyHbT1agr1ZYPiBNtw2zBOIaL7YVg=
Date: Fri, 19 Mar 2010 14:44:11 +0300
From: Dan Carpenter <error27@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] sbshc: acpi_device_class "smbus_host_controller" too long
Message-ID: <20100319114411.GM5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alexey Starikovskiy <astarikovskiy@suse.de>,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_device_class can only be 19 characters and a NULL terminator.

With the current name we get a buffer overflow in acpi_smbus_hc_add()
when we do: 
	strcpy(acpi_device_class(device), ACPI_SMB_HC_CLASS);

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index fd09229..1fbf073 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -17,7 +17,7 @@
 
 #define PREFIX "ACPI: "
 
-#define ACPI_SMB_HC_CLASS	"smbus_host_controller"
+#define ACPI_SMB_HC_CLASS	"smbus_host_ctl"
 #define ACPI_SMB_HC_DEVICE_NAME	"ACPI SMBus HC"
 
 struct acpi_smb_hc {
