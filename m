Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab0JVTBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:01:00 -0400
Received: from kroah.org ([198.145.64.141]:34472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463Ab0JVS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:57:13 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:35 2010
Message-Id: <20101022185235.848764546@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:52:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [095/103] x86: detect scattered cpuid features earlier
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

commit 1dedefd1a066a795a87afca9c0236e1a94de9bf6 upstream.

Some extra CPU features such as ARAT is needed in early boot so
that x86_init function pointers can be set up properly.
http://lkml.org/lkml/2010/5/18/519
At start_kernel() level, this patch moves init_scattered_cpuid_features()
from check_bugs() to setup_arch() -> early_cpu_init() which is earlier than
platform specific x86_init layer setup. Suggested by HPA.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
LKML-Reference: <1274295685-6774-2-git-send-email-jacob.jun.pan@linux.intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -576,6 +576,7 @@ void __cpuinit get_cpu_cap(struct cpuinf
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	init_scattered_cpuid_features(c);
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
@@ -731,7 +732,6 @@ static void __cpuinit generic_identify(s
 
 	get_model_name(c); /* Default name */
 
-	init_scattered_cpuid_features(c);
 	detect_nopl(c);
 }
 


