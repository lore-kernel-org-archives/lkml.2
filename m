Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126Ab2KASUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:20:53 -0400
Received: from mails.cs.uwaterloo.ca ([129.97.167.217]:57999 "EHLO
	mails.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2KASUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:20:52 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 14:20:52 EDT
Message-ID: <5092BA34.5030009@uwaterloo.ca>
Date: Thu, 01 Nov 2012 14:06:44 -0400
From: Sarah Nadi <snadi@uwaterloo.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
CC: mst@redhat.com, daniel@numascale-asia.com, sp@numascale.com,
        linux-kernel@vger.kernel.org
Subject: PATCH: Remove redundant #ifdef check in arch/x86/kernel/apic/bigsmp_32.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Miltered: at mailchk-m03 with ID 5092BA39.001 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Nadi <snadi@uwaterloo.ca>

Based on v3.5-rc1, #ifdef check in arch/x86/kernel/apic/bigsmp_32.c is 
redundant as SMP will always be selected for the file to compile any 
ways (file compiles when X86_BIGSMP is selected, and X86_BIGSMP depends 
on SMP). The first block is always selected, and #else code block is 
therefore always dead. See patch below.

--- linux/arch/x86/kernel/apic/bigsmp_32.c.orig    2012-11-01 
13:53:24.781158327 -0400
+++ linux/arch/x86/kernel/apic/bigsmp_32.c    2012-11-01 
13:54:39.501438248 -0400
@@ -28,11 +28,7 @@ static int bigsmp_apic_id_registered(voi

  static const struct cpumask *bigsmp_target_cpus(void)
  {
-#ifdef CONFIG_SMP
      return cpu_online_mask;
-#else
-    return cpumask_of(0);
-#endif
  }

  static unsigned long bigsmp_check_apicid_used(physid_mask_t *map, int 
apicid)


Signed-off-by: Sarah Nadi <snadi@uwaterloo.ca>
