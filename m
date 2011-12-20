Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LTSTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:19:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:54229 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1LTSS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:18:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98439219"
Date: Tue, 20 Dec 2011 10:18:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/autoprobe] x86, cpufreq: Add support for x86 cpuinfo
 auto loading
Message-ID: <20111220181856.GB31168@tassilo.jf.intel.com>
References: <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <tip-c347c2092efcd7d4fc1575057db7a42c1fc15ec5@git.kernel.org>
 <20111220101201.GB20788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220101201.GB20788@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/cpufreq/gx-suspmod.c:175:35: error: macro "MODULE_DEVICE_TABLE" requires 2 arguments, but only 1 given
> 
> You have not even build tested this change?

I did an allyes build, but only on 64bit. Forgot it's a 32bit only driver.
Sorry. Here's an incremential if you haven't fixed it already.

-Andi


Fix 32bit build for gx-suspmod.c

Pointed out by the friendly maintainer.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index 5a06c0b..456bee0 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -172,7 +172,7 @@ static struct pci_device_id gx_chipset_tbl[] __initdata = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 	{ 0, },
 };
-MODULE_DEVICE_TABLE(gx_chipset_tbl);
+MODULE_DEVICE_TABLE(pci, gx_chipset_tbl);
 
 static void gx_write_byte(int reg, int value)
 {



-- 
ak@linux.intel.com -- Speaking for myself only
