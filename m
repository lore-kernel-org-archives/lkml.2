Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0LUVni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:43:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0LUVna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:43:30 -0500
Date: Tue, 21 Dec 2010 16:43:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 21 (nmi watchdog)
Message-ID: <20101221214323.GA23095@redhat.com>
References: <20101221190526.068b2b31.sfr@canb.auug.org.au>
 <20101221091047.06de6334.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221091047.06de6334.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 09:10:47AM -0800, Randy Dunlap wrote:
> On Tue, 21 Dec 2010 19:05:26 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > [The mirroring on kernel.org is running slowly]
> > 
> > Changes since 20101220:
> 
> 
> kernel/built-in.o: In function `watchdog_nmi_enable':
> watchdog.c:(.text+0x58539): undefined reference to `hw_nmi_get_sample_period'
> 
> 
> kernel config file is attached.

I have a bigger clean up patch that I sent to Ingo that fixes this
correctly.  But for now, you can use this patch.

Cheers,
Don


diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 93da91d..a4fa849 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -17,7 +17,6 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 
-#ifdef ARCH_HAS_NMI_WATCHDOG
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
 {
@@ -25,6 +24,7 @@ u64 hw_nmi_get_sample_period(void)
 }
 #endif
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
 #ifndef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
