Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0IMK0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:26:40 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56566 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMK0j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Mon, 13 Sep 2010 06:26:39 -0400
Message-Id: <4C8E18790200007800015AF7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 13 Sep 2010 11:26:33 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <fenghua.yu@intel.com>, <khali@linux-fr.org>
Cc: <r.marek@assembler.cz>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/hwmon: conditionalize coretemp's dependency on PCI
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI specific code is needed only when Atom CPUs are potentially
supported by the kernel.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rudolf Marek <r.marek@assembler.cz>

---
 drivers/hwmon/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.36-rc4/drivers/hwmon/Kconfig	2010-09-13 08:45:02.000000000 +0200
+++ 2.6.36-rc4-x86-coretemp-maybe-pci/drivers/hwmon/Kconfig	2010-09-10 16:24:16.000000000 +0200
@@ -401,7 +401,8 @@ config SENSORS_GL520SM
 
 config SENSORS_CORETEMP
 	tristate "Intel Core/Core2/Atom temperature sensor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && EXPERIMENTAL
+	depends on PCI || (!MATOM && !GENERIC_CPU && !X86_GENERIC)
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Most of the family 6 CPUs



