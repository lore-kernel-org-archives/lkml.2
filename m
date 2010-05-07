Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0EGQlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:41:51 -0400
Received: from mail-qy0-f195.google.com ([209.85.221.195]:56008 "EHLO
	mail-qy0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0EGQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=L3Cq4QwnhK6g0NLL7sabdavaOXHpIvL16fFIhcrVKTtjp+MXQDGMUTcse1JB8qWb/h
         LsdZaWVyCUbbkVj9g7Y/Lb0XHHCnYxo8f650nBLoGvC1NKtonNcc8csy+4TPFWbkMrHW
         K+/mBSYTj+PjZbJVQT1Pp+ZoNUGIA5AgtLTLU=
Date: Fri, 7 May 2010 12:41:40 -0400
From: John Villalovos <sodarock@gmail.com>
To: andi@firstfloor.org, linux-kernel@vger.kernel.org, x86@kernel.org,
       robert.richter@amd.com, oprofile-list@lists.sf.net
Subject: [PATCH V2] Oprofile: Change CPUIDS from decimal to hex, and add some
 comments
Message-ID: <20100507164140.GA6128@linuxjohn.usersys.redhat.com>
Reply-To: John Villalovos <sodarock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2:

Incorporating suggested changes from Robert Richter.

Back when the patch was submitted for "Add Xeon 7500 series support to
oprofile", Robert Richter had asked for a followon patch that converted all the
CPU ID values to hex.

I have done that here for the "i386/core_i7" and "i386/atom" class
processors in the ppro_init() function and also added some comments on
where to find documentation on the Intel processors.

Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 9f001d9..2de5f44 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -586,6 +586,13 @@ static int __init ppro_init(char **cpu_type)
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
 
+	/* Documentation on identifying Intel processors by CPU Family and Model
+	 * can be found in the Intel Software Developer's Manual (SDM).
+	 * http://www.intel.com/products/processor/manuals/
+	 * As of May 2010 the documentation for this was in the:
+	 * "Intel 64 and IA-32 Architectures Software Developer's Manual Volume
+	 * 3B: System Programming Guide",
+	 * "Table B-1 CPUID Signature Values of DisplayFamily_DisplayModel" */
 	switch (cpu_model) {
 	case 0 ... 2:
 		*cpu_type = "i386/ppro";
@@ -607,12 +614,12 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 0x1a:
 	case 0x2e:
-	case 26:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
-	case 28:
+	case 0x1c:
 		*cpu_type = "i386/atom";
 		break;
 	default:


-- 
John Villalovos
Intel Corporation on-site partner engineer at Red Hat, Inc.

