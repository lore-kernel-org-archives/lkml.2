Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab1LGWqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 17:46:53 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:34211 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab1LGWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 17:46:52 -0500
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Dec 2011 17:46:50 EST
Message-ID: <1323297487.4edfeacfc49ff@imp.free.fr>
Date: Wed, 07 Dec 2011 23:38:07 +0100
From: wallak@free.fr
To: linux-kernel@vger.kernel.org
Subject: ACPI "_PDC" - acpi_processor_set_pdc()- execution regression - Linux-3.x
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 88.161.131.83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a regression on the ACPI stack of the last linux kernel line 3.x (3.1.4,
3.2-rc4...). The ACPI "_PDC" chunk is not executed on some computers (e.g. Dell
X300; the function acpi_processor_set_pdc() is not called). This issue yield to
an uninitialized state of some ACPI variables.

A patch is available below. This patch come back to the previous linux behavior,
and works fine.

Best Regards,
Wallak.

--- linux-3.1.4-mdf/drivers/acpi/processor_core.c.orig  2011-12-07
23:12:57.000000000 +0100
+++ linux-3.1.4-mdf/drivers/acpi/processor_core.c       2011-12-07
23:13:39.000000000 +0100
@@ -223,8 +223,8 @@
        type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
        cpuid = acpi_get_cpuid(handle, type, acpi_id);

-       if (cpuid == -1)
-               return false;
+       if ((cpuid == -1) && (num_possible_cpus() > 1))
+               return false;

        return true;
 }
