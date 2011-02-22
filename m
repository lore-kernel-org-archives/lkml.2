Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BVDUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:20:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42243 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1BVDUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SxSrQuEAaR+wW++N8HVB6atTX4FnKTZTHcy81zYKYpjeiBADMFOg8tn/aNK8BtQ6i3
         z4VTjTJOfjOEQIGzYHccJedymPWGogvoMQbNtiDxt8hVNXKX2NPiNXglpz8SYcbaHE6H
         fbM4Kmw1TlQKG227WI4BL1nz/4/Gs2TzP0CJs=
Subject: [PATCH] davinci: cpufreq: fix section mismatch warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain
Date: Tue, 22 Feb 2011 11:23:53 +0800
Message-Id: <1298345033.3903.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below section mismatch warning:
WARNING: vmlinux.o(.data+0x673c): Section mismatch in reference from the variable davinci_driver to the function .init.text:davinci_cpu_init()
The variable davinci_driver references
the function __init davinci_cpu_init()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-davinci/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 343de73..4a68c2b 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -132,7 +132,7 @@ out:
 	return ret;
 }
 
-static int __init davinci_cpu_init(struct cpufreq_policy *policy)
+static int davinci_cpu_init(struct cpufreq_policy *policy)
 {
 	int result = 0;
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
-- 
1.7.2



