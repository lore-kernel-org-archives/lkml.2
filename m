Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0JUL2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:28:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36932 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0JUL2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Nusol3wgsDuIlTjoN7+laMEOI6gm9G2y1H5jJzOcaH8QjC5Zi4ZWup+4fRoxcY6xNu
         6uE8htysHc7FUJRVwYOBF4ZKuDM3muVYOdbJ/6sl7uqlASVz+eMqFUc9IwcMG0bvpabV
         K89l18OyUsW+j5sT4luv9rNn13K05Om/VqXek=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 17:28:44 +0600
Message-ID: <AANLkTimTi_NTSampvrxXMVj5UTCR+p5wxLCQdnY8Rc4+@mail.gmail.com>
Subject: [PATCH]: x86, cpufreq: Mark longrun_get_policy with __cpuinit.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning. The function
longrun_cpu_init() is marked with __cpuinit which calls
longrun_get_policy() which is a __init function. So make
longrun_get_policy with __cpuinit.

WARNING: arch/x86/kernel/cpu/cpufreq/longrun.o(.cpuinit.text+0x4c5):
Section mismatch in reference from the function longrun_cpu_init() to
the function .init.text:longrun_get_policy()
The function __cpuinit longrun_cpu_init() references
a function __init longrun_get_policy().
If longrun_get_policy is only used by longrun_cpu_init then
annotate longrun_get_policy with a matching annotation.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/cpu/cpufreq/longrun.c
b/arch/x86/kernel/cpu/cpufreq/longrun.c
index fc09f14..66d5d6f 100644
--- a/arch/x86/kernel/cpu/cpufreq/longrun.c
+++ b/arch/x86/kernel/cpu/cpufreq/longrun.c
@@ -35,7 +35,7 @@ static unsigned int longrun_low_freq, longrun_high_freq;
  * Reads the current LongRun policy by access to MSR_TMTA_LONGRUN_FLAGS
  * and MSR_TMTA_LONGRUN_CTRL
  */
-static void __init longrun_get_policy(struct cpufreq_policy *policy)
+static void __cpuinit longrun_get_policy(struct cpufreq_policy *policy)
 {
 	u32 msr_lo, msr_hi;
