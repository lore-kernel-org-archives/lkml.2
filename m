Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab1AIG3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 01:29:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51237 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1AIG3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 01:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=S7pEGRDmy6wnbRJBGG1H0K/edWAr57QJh9igBscRDDkqZETynd8DOQq/FaSiLfR0bC
         IKowUpX2nAelrobINlteN79jEJlwig2FKuRu74Bmd+CR3poKwcnhWc35aVDseC/PAeTp
         9dOPEkoMjfgHHUc+MTXFoZoLN+14NxkhcIhFc=
MIME-Version: 1.0
Date: Sun, 9 Jan 2011 12:29:39 +0600
Message-ID: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
Subject: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 disabled_cpus has been incremented from the call path of
generic_processor_info (i.e from  acpi_register_lapic and
MP_processor_info) when a perticular cpu is not enabled. So, we can
remove the redundant increment of disabled_cpus from
generic_processor_info.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ce65d44..2499664 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1943,7 +1943,6 @@ void __cpuinit generic_processor_info(int
apicid, int version)
 			"ACPI: NR_CPUS/possible_cpus limit of %i reached."
 			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);

-		disabled_cpus++;
 		return;
 	}
