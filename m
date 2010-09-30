Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab0I3Tne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:43:34 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:47037 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756477Ab0I3Tnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:43:33 -0400
Subject: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: davej@redhat.com, cpufreq@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 15:43:24 -0400
Message-ID: <1285875804.2180.1.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, cpufreq: avoid an unnecessary double free when finished in pcc_cpufreq_do_osc()

There is no need to fall through the out_free label thus saving a kfree call.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
index 994230d..db7dc35 100644
--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -379,6 +379,8 @@ static int __init pcc_cpufreq_do_osc(acpi_handle *handle)
 	if (!(supported & 0x1))
 		return -ENODEV;
 
+	return ret;
+
 out_free:
 	kfree(output.pointer);
 	return ret;
-- 
1.7.0.4



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



