Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab1IXFAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 01:00:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27618 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1IXFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 01:00:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org
Subject: [PATCH] Xen MMU fixes for 3.2 (v1)
Date: Fri, 23 Sep 2011 22:28:16 -0400
Message-Id: <1316831299-4144-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020203.4E7D63EA.0020:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these three patches for 3.2.

[PATCH 1/3] Revert "xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set."

.. which just removes code that was meant there to be for some releases to
check if we forgot something. And it looks like we have covered all the boundary
cases for the 1-1 identity pages.
[PATCH 2/3] xen/p2m: Make debug/xen/mmu/p2m visible again.

.. was removed in v3.0 by the Xen MMU tracing updated by mistake. Puts it
back in.

[PATCH 3/3] xen/p2m: Use SetPagePrivate and its friends for M2P overrides.

.. and will now warn us if somebody has overwritten the MFN of the 'struct page'
(of the pages that are in the M2P override) and also use the appropiate macros.

 arch/x86/include/asm/xen/page.h |    3 --
 arch/x86/xen/Kconfig            |    8 ------
 arch/x86/xen/mmu.c              |   52 ---------------------------------------
 arch/x86/xen/p2m.c              |   45 ++++++++++++++++++++++++++++-----
 4 files changed, 38 insertions(+), 70 deletions(-)
