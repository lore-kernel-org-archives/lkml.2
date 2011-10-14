Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1JNWiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:38:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34758 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1JNWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:38:08 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: [PATCH 2/2] xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible defaults for 32-bit builds
Date: Fri, 14 Oct 2011 15:36:51 -0700
Message-Id: <1318631811-21559-3-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
References: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090209.4E98B9CD.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is that 128GB is not going to happen with 32-bit PV DomU.
Lets use something more realistic.

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 0b452c7..6d90ac8 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -29,7 +29,8 @@ config XEN_PVHVM
 
 config XEN_MAX_DOMAIN_MEMORY
        int "Maximum allowed size of a domain in gigabytes"
-       default 128
+       default 128 if X86_64
+       default 64 if X86_32
        depends on XEN
        help
          This only affects the sizing of some bss arrays, the unused
-- 
1.7.4.1

