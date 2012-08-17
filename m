Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030854Ab2HQDfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:35:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030633Ab2HQD04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:56 -0400
Message-Id: <20120817030246.408699559@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Bader <stefan.bader@canonical.com>,
        Avi Kivity <avi@redhat.com>
Subject: [ 17/37] KVM: VMX: Advertise CPU_BASED_RDPMC_EXITING for nested guests
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

Based on commit fee84b079d5ddee2247b5c1f53162c330c622902 upstream.

  Intercept RDPMC and forward it to the PMU emulation code.

Newer vmx support will only allow to load the kvm_intel module
if RDPMC_EXITING is supported. Even without the actual support
this part of the change is required on 3.2 hosts.

BugLink: http://bugs.launchpad.net/bugs/1031090
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1956,6 +1956,7 @@ static __init void nested_vmx_setup_ctls
 #endif
 		CPU_BASED_MOV_DR_EXITING | CPU_BASED_UNCOND_IO_EXITING |
 		CPU_BASED_USE_IO_BITMAPS | CPU_BASED_MONITOR_EXITING |
+		CPU_BASED_RDPMC_EXITING |
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
 	/*
 	 * We can allow some features even when not supported by the


