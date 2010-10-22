Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab0JVVN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:13:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53470 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab0JVVN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:13:27 -0400
Date: Fri, 22 Oct 2010 14:13:05 -0700
From: Vernon Mauery <vernux@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: [Patch 1/2] ibm_rtl: DMI match should include all IBM machines
Message-ID: <20101022211305.GH8754@lucy>
References: <20101005224718.GC4046@lucy>
 <20101021135429.GC22133@srcf.ucam.org>
 <20101021142319.GA8754@lucy>
 <20101021142523.GA23171@srcf.ucam.org>
 <20101021143821.GB8754@lucy>
 <20101021144234.GA23552@srcf.ucam.org>
 <20101021150928.GC8754@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101021150928.GC8754@lucy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-Oct-2010 08:09 AM, Vernon Mauery wrote:
>No, if it has the _RTL_ header it should be fine.  I was more 
>concerned about the driver trying to map the EBDA and reading through 
>it on non-ibm platforms, so I guess just a check to see that it is 
>IBM should be sufficient.  Let me get a patch that does that.

This patch should do just that:

--Vernon

ibm_rtl: Loosen the DMI criteria to match all IBM machines

Allow all IBM machines to pass the DMI check so that we
don't have to add them one by one to the driver.  Any IBM
machine that has the _RTL_ table in the EBDA will work.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 3c2c6b9..c5a0061 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -220,32 +220,13 @@ static void rtl_teardown_sysfs(void) {
  	sysdev_class_unregister(&class_rtl);
  }
  
-static int dmi_check_cb(const struct dmi_system_id *id)
-{
-	RTL_DEBUG("found IBM server '%s'\n", id->ident);
-	return 0;
-}
-
-#define ibm_dmi_entry(NAME, TYPE)                  \
-{                                                  \
-	.ident = NAME,                             \
-	.matches = {                               \
-		DMI_MATCH(DMI_SYS_VENDOR, "IBM"),  \
-		DMI_MATCH(DMI_PRODUCT_NAME, TYPE), \
-	},                                         \
-	.callback = dmi_check_cb                   \
-}
  
  static struct dmi_system_id __initdata ibm_rtl_dmi_table[] = {
-	ibm_dmi_entry("BladeCenter LS21", "7971"),
-	ibm_dmi_entry("BladeCenter LS22", "7901"),
-	ibm_dmi_entry("BladeCenter HS21 XM", "7995"),
-	ibm_dmi_entry("BladeCenter HS22", "7870"),
-	ibm_dmi_entry("BladeCenter HS22V", "7871"),
-	ibm_dmi_entry("System x3550 M2", "7946"),
-	ibm_dmi_entry("System x3650 M2", "7947"),
-	ibm_dmi_entry("System x3550 M3", "7944"),
-	ibm_dmi_entry("System x3650 M3", "7945"),
+	{                                                  \
+		.matches = {                               \
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),  \
+		},                                         \
+	},
  	{ }
  };
  
