Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1I1Wpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896Ab1I1Wpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.727122597@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Dave Jones <davej@codemonkey.org.uk>, Len Brown <lenb@kernel.org>
Subject: [127/244] drivers/cpufreq/pcc-cpufreq.c: avoid NULL pointer dereference
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

commit e71f5cc402ecb42b407ae52add7b173bf1c53daa upstream.

per_cpu(processors, n) can be NULL, resulting in:

  Loading CPUFreq modules[  437.661360] BUG: unable to handle kernel NULL pointer dereference at (null)
  IP: [<ffffffffa0434314>] pcc_cpufreq_cpu_init+0x74/0x220 [pcc_cpufreq]

It's better to avoid the oops by failing the driver, and allowing the
system to boot.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/pcc-cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -261,6 +261,9 @@ static int pcc_get_offset(int cpu)
 	pr = per_cpu(processors, cpu);
 	pcc_cpu_data = per_cpu_ptr(pcc_cpu_info, cpu);
 
+	if (!pr)
+		return -ENODEV;
+
 	status = acpi_evaluate_object(pr->handle, "PCCP", NULL, &buffer);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;


