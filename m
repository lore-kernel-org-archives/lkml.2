Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab2C3UmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:42:20 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47237 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2C3UmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] fix /proc/meminfo reporting (v1)
Date: Fri, 30 Mar 2012 16:37:23 -0400
Message-Id: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F761A9C.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix that by making the kernel work like the classic Xen kernel.

 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/p2m.c              |  104 +++++++++++++++++++++++---------------
 arch/x86/xen/setup.c            |  106 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 164 insertions(+), 47 deletions(-)

Konrad Rzeszutek Wilk (7):
      xen/p2m: Move code around to allow for better re-usage.
      xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
      xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
      xen/p2m: An early bootup variant of set_phys_to_machine
      xen/setup: Transfer MFNs from non-RAM E820 entries and gaps to E820 RAM
      xen/setup: Make dom0_mem=XGB behavior be similar to classic Xen kernels.
      xen/setup: Only print "Freeing  XXX-YYY pfn range: Z pages freed" if Z > 0

