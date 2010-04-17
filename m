Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0DQA6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 20:58:34 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:49027 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652Ab0DQA6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 20:58:33 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.589
Message-ID: <4BC907B5.2050104@tremplin-utc.net>
Date: Sat, 17 Apr 2010 02:58:29 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Make WMI be selected automatically when needed
References: <4BC8FF9D.7050500@tremplin-utc.net> <20100416173127.6b968fd4.randy.dunlap@oracle.com>
In-Reply-To: <20100416173127.6b968fd4.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 17-04-10 02:31, Randy Dunlap schreef:
> On Sat, 17 Apr 2010 02:23:57 +0200 Éric Piel wrote:
> 
>> Many different modules depend on WMI. In Kconfig, some used to "depend"
>> on it, while others "selected" it. As WMI by itself is useless and more
>> like a library, it's easier for the user to have it automatically
>> selected whenever needed. It's especially true for options in completely
>> different places (like LEDS_DELL_NETBOOKS). So we consistently "select"
>> it.
>>
>> Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
> 
> config ACPI_WMI
> 	tristate "WMI"
> 	depends on ACPI
> 
> so what happens when one of these configs selects ACPI_WMI
> but ACPI is not enabled?  Hint:  that will not enable ACPI.
> 
> Did you test that kconfig combination?
Indeed, I hadn't really thought of no ACPI support at all... I guess the best
is to just do like the other config which select ACPI_WMI, make them depend
on ACPI. Sounds good to you? (new version appended)

Eric

8<------------------------------
Many different modules depend on WMI. In Kconfig, some used to "depend"
on it, while others "selected" it. As WMI by itself is useless and more
like a library, it's easier for the user to have it automatically
selected whenever needed. It's especially true for options in completely
different places (like LEDS_DELL_NETBOOKS). So we consistently "select"
it.

v2: depend on ACPI to avoid selecting ACPI_WMI without ACPI.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/leds/Kconfig         |    4 +++-
 drivers/platform/x86/Kconfig |   12 ++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 505eb64..f937f88 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -280,7 +280,9 @@ config LEDS_ADP5520
 
 config LEDS_DELL_NETBOOKS
 	tristate "External LED on Dell Business Netbooks"
-	depends on X86 && ACPI_WMI
+	depends on X86
+	depends on ACPI
+	select ACPI_WMI
 	help
 	  This adds support for the Latitude 2100 and similar
 	  notebooks that have an external LED.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7bec458..28c33e8 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -89,8 +89,9 @@ config DELL_LAPTOP
 
 config DELL_WMI
 	tristate "Dell WMI extras"
-	depends on ACPI_WMI
 	depends on INPUT
+	depends on ACPI
+	select ACPI_WMI
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Dell laptops.
 
@@ -136,9 +137,10 @@ config TC1100_WMI
 
 config HP_WMI
 	tristate "HP WMI extras"
-	depends on ACPI_WMI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	depends on ACPI
+	select ACPI_WMI
 	help
 	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
 	 to read data from WMI such as docking or ambient light sensor state.
@@ -387,9 +389,10 @@ config EEEPC_LAPTOP
 
 config EEEPC_WMI
 	tristate "Eee PC WMI Hotkey Driver (EXPERIMENTAL)"
-	depends on ACPI_WMI
 	depends on INPUT
 	depends on EXPERIMENTAL
+	depends on ACPI
+	select ACPI_WMI
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
 
@@ -419,9 +422,10 @@ config ACPI_WMI
 
 config MSI_WMI
 	tristate "MSI WMI extras"
-	depends on ACPI_WMI
 	depends on INPUT
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on ACPI
+	select ACPI_WMI
 	select INPUT_SPARSEKMAP
 	help
 	 Say Y here if you want to support WMI-based hotkeys on MSI laptops.
-- 
1.7.0.5


 
