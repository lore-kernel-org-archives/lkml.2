Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab2BBOhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:37:09 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36805 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2BBOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:37:07 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 09:37:07 EST
Date: Thu, 2 Feb 2012 15:26:28 +0100
From: Borislav Petkov <bp@amd64.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@amd64.org>
Subject: Re: linux-next: Tree for Feb 1 (mce_amd.c)
Message-ID: <20120202142628.GA1052@aftab>
References: <20120201171643.cbf8263eded709a75e92f4ad@canb.auug.org.au>
 <4F298A6C.6010101@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F298A6C.6010101@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 10:54:36AM -0800, Randy Dunlap wrote:
> On 01/31/2012 10:16 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20120131:
> 
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'

Yeah, -rc2 has that problem too with your randconfig. The issue is with
CONFIG_SMP not being set.

The following chunk should cure it:

--
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..63fcb8a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -897,7 +897,7 @@ config X86_MCE_INTEL
 config X86_MCE_AMD
 	def_bool y
 	prompt "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
+	depends on X86_MCE && X86_LOCAL_APIC && SMP
 	---help---
 	   Additional support for AMD specific MCE features such as
 	   the DRAM Error Threshold.
--

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
