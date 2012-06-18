Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2FRK2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:28:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51226 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2FRK2t convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 18 Jun 2012 06:28:49 -0400
Message-Id: <4FDF1EFD020000780008A65D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 18 Jun 2012 11:28:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/microcode: microcode_id[] can be __initconst
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not being used for other than creating module aliases (i.e. no
loadable section has any reference to it).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/microcode_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.5-rc3/arch/x86/kernel/microcode_core.c
+++ 3.5-rc3-x86-microcode-sections/arch/x86/kernel/microcode_core.c
@@ -504,7 +504,7 @@ static struct notifier_block __refdata m
 
 #ifdef MODULE
 /* Autoload on Intel and AMD systems */
-static const struct x86_cpu_id microcode_id[] = {
+static const struct x86_cpu_id __initconst microcode_id[] = {
 #ifdef CONFIG_MICROCODE_INTEL
 	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, },
 #endif



