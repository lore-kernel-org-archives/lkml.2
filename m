Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1LGVGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:06:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab1LGVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:06:35 -0500
Date: Wed, 7 Dec 2011 16:06:30 -0500
From: Don Zickus <dzickus@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 7 (x86, not SMP)
Message-ID: <20111207210630.GI1669@redhat.com>
References: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au>
 <4EDFBA25.1020102@xenotime.net>
 <20111207194252.GH1669@redhat.com>
 <4EDFCFF9.2080906@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDFCFF9.2080906@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 12:43:37PM -0800, Randy Dunlap wrote:
> On 12/07/2011 11:42 AM, Don Zickus wrote:
> > On Wed, Dec 07, 2011 at 11:10:29AM -0800, Randy Dunlap wrote:
> >> On 12/06/2011 10:12 PM, Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20111206:
> >>
> >>
> >> When CONFIG_SMP is not enabled:
> >> (I think that's the cause, but it could be some other kconfig option.)
> > 
> > Yeah it doesn't seem to be that one.  I think it is CONFIG_X86_LOCAL_APIC,
> > but I can't quickly figure out how to disable it (it keeps getting
> > re-enabled somewhere).
> > 
> > Can you attach your .config?
> 
> Certainly. Done.
> Thanks.

Ok, I was right it does depend on the local apic.  The following patch
fixed the problem for me.

Cheers,
Don 
-----8<----

From: Don Zickus <dzickus@redhat.com>
Date: Wed, 7 Dec 2011 16:03:40 -0500
Subject: [PATCH] x86, NMI: NMI selftest depends on the local apic

The selftest doesn't work with out a local apic for now.

Reported-by: Randy Durlap <rdunlap@xenotime.net>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 020a4f1..d6eea6d 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -286,7 +286,7 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 config DEBUG_NMI_SELFTEST
 	bool "NMI Selftest"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && X86_LOCAL_APIC
 	---help---
 	  Enabling this option turns on a quick NMI selftest to verify
 	  that the NMI behaves correctly.
-- 
1.7.6.4

