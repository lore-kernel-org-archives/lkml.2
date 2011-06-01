Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161901Ab1FAIPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:15:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161859Ab1FAIPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:32 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:50 2011
Message-Id: <20110601081050.347027350@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:35 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [005/165] [CPUFREQ] Fix _OSC UUID in pcc-cpufreq
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1193
Lines: 39

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

commit 904cc1e637a00dba1b58e7752f485f90ebf2a568 upstream.

UUID needs to be written out the way it is described in
Sec 18.5.124 of ACPI 4.0a Specification.

Platform firmware's use of this UUID/_OSC is optional, which is
why we didn't notice this bug earlier.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -39,7 +39,7 @@
 
 #include <acpi/processor.h>
 
-#define PCC_VERSION 	"1.00.00"
+#define PCC_VERSION	"1.10.00"
 #define POLL_LOOPS 	300
 
 #define CMD_COMPLETE 	0x1
@@ -102,7 +102,7 @@ static struct acpi_generic_address doorb
 static u64 doorbell_preserve;
 static u64 doorbell_write;
 
-static u8 OSC_UUID[16] = {0x63, 0x9B, 0x2C, 0x9F, 0x70, 0x91, 0x49, 0x1f,
+static u8 OSC_UUID[16] = {0x9F, 0x2C, 0x9B, 0x63, 0x91, 0x70, 0x1f, 0x49,
 			  0xBB, 0x4F, 0xA5, 0x98, 0x2F, 0xA1, 0xB5, 0x46};
 
 struct pcc_cpu {


