Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1DTPIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:08:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57849 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1DTPIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=wJvROVznczTmpcIfrvkJHI5Bl7xFV5bgKf8KIhkOtPJ4Vm2MyWLEkpQNBsHQBE+qw2
         4lq7djj37SeoZlmxp49zRaHgp4mZaNXY4hsvC2cWUPotvk1/jShEiMRMCSWucYd7zZTB
         tfXrFzgJnmJZ9q80e3usK63DMq5pHS+GQYfU8=
Message-ID: <4DAEF701.5090402@openvz.org>
Date: Wed, 20 Apr 2011 19:08:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] perf, x86: P4 PMU -- Use perf_sample_data_init helper
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of opencoded assignments better to use
perf_sample_data_init helper.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_r
 	int idx, handled = 0;
 	u64 val;

-	data.addr = 0;
-	data.raw = NULL;
+	perf_sample_data_init(&data, 0);

 	cpuc = &__get_cpu_var(cpu_hw_events);


-- 
    Cyrill
