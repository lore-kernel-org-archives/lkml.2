Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0DPRJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:09:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36301 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab0DPRJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=Es3iL3zVaS5FQ6EEorMnZdgc6+tpJwG40hTtTUo9hfyNJQdneEOlDw2csAciW6wMw8
         wj6Bje7lOqQuiTtGO7iZIcaDnHpUGBVXu/nV0hkaOiVXLBOFW/pNTAe9Q/0ZHWeQzFEF
         OM5I+AG2mdjrXwObaah2Rg/NsLfLMN3aCGcW8=
Date: Fri, 16 Apr 2010 13:08:49 -0400
From: John Villalovos <sodarock@gmail.com>
To: andi@firstfloor.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       robert.richter@amd.com, oprofile-list@lists.sf.net
Subject: [PATCH] Oprofile: Change CPUIDS from decimal to hex, and add some
 comments
Message-ID: <20100416170849.GA15932@linuxjohn.usersys.redhat.com>
Reply-To: John Villalovos <sodarock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back when the patch was submitted for "Add Xeon 7500 series support to
oprofile", Robert Richter had asked for a follown patch that converted
all the CPU ID values to hex.

I have done that here for the processors in the ppro_init() function and also
added some documentation as comments that I retrieved from the Intel Software
Developer's Manual (SDM) March 2010 edition in Volume 3B, Table B-1.

The Intel SDM can be found at:
http://www.intel.com/products/processor/manuals/

I also added processor codenames for some of the newer processors.

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2c505ee..9cd591e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -579,32 +579,53 @@ static int __init ppro_init(char **cpu_type)
 		return 0;
 
 	switch (cpu_model) {
-	case 0 ... 2:
+	case 0x00 ... 0x02:
+	/* 06_01H: Intel Pentium Pro Processor */
 		*cpu_type = "i386/ppro";
 		break;
-	case 3 ... 5:
+	case 0x03 ... 0x05:
+	/* 06_03H, 06_05H: Intel Pentium II Xeon Processor, Intel Pentium II
+	 * Processor */
 		*cpu_type = "i386/pii";
 		break;
-	case 6 ... 8:
-	case 10 ... 11:
+	case 0x06 ... 0x08:
+	case 0x0A ... 0x0B:
+	/* 06_07H, 06_08H, 06_0AH, 06_0BH: Intel Pentium III Xeon Processor,
+	 * Intel Pentium III Processor */
 		*cpu_type = "i386/piii";
 		break;
-	case 9:
-	case 13:
+	case 0x09:
+	case 0x0D:
+	/* 06_09H, 06_0DH: Intel Pentium M processor */
 		*cpu_type = "i386/p6_mobile";
 		break;
-	case 14:
+	case 0x0E:
+	/*  06_0EH: Intel Core Duo, Intel Core Solo processors */
 		*cpu_type = "i386/core";
 		break;
-	case 15: case 23:
+	case 0x0F:
+	/* 06_0FH: Intel Xeon Processor 3000, 3200, 5100, 5300, 7300 series,
+	 * Intel Core 2 Quad processor 6000 series, Intel Core 2 Extreme 6000
+	 * series, Intel Core 2 Duo 4000, 5000, 6000, 7000 series processors,
+	 * Intel Pentium dual-core processors.
+	 * Code names: Clovertown, Conroe, Kentsfield, Merom, Tigerton, and
+	 * Woodcrest. */
+	case 0x17:
+	/* 06_17H: Intel Xeon Processor 5200, 5400 series, Intel Core 2 Quad
+	 * processors 8000, 9000 series.
+	 * Code names: Harpertown, Penryn, Wolfdale, and Yorkfield */
 		*cpu_type = "i386/core_2";
 		break;
-	case 0x2e:
-	case 26:
+	case 0x1A:
+	/* 06_1AH: Intel Core i7 Processor, Intel Xeon Processor 5500 series
+	 * Code names: Bloomfield and Nehalem-EP */
+	case 0x2E:
+	/* 06_2EH: Intel Xeon 6500/7500 series codenamed Nehalem-EX/Beckton */
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
-	case 28:
+	case 0x1C:
+	/* 06_1CH: Intel Atom processor */
 		*cpu_type = "i386/atom";
 		break;
 	default:
-- 
John Villalovos
Intel Corporation on-site partner engineer at Red Hat, Inc.

http://tabasco.usersys.redhat.com/
