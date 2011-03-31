Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab1CaQiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:38:20 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54985 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1CaQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:38:19 -0400
X-IronPort-AV: E=Sophos;i="4.63,276,1299456000"; 
   d="scan'208";a="5081858"
Date: Thu, 31 Mar 2011 17:38:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Greg KH <gregkh@suse.de>, <lkml20101129@newton.leun.net>
Subject: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Message-ID: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save cr4 to mmu_cr4_features at boot time

This patch fixes a freeze when resuming from hibernation, introduced by
"x86: Cleanup highmap after brk is concluded", commit id
e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.
This patch should be backported to all the stable tree where the
offending commit is present.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-by: Michael Leun <lkml20101129@newton.leun.net>
CC: Yinghai Lu <yinghai@kernel.org>
CC: stable <stable@kernel.org>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5a0484a..0943eb2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -891,6 +891,7 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	mmu_cr4_features = read_cr4();
 #endif
 
 	/*
