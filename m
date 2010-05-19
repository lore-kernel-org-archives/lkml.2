Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab0ESFfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:35:33 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:39952 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0ESFfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OUAg5yJQE2NUDKD4JQu1RiAWvjuHxrEJEnt9MXMfV6dHH1d53BMlWKAHk04okQ3Wgr
         UOXatsHTfWt81WoA39Mpsl/lFRNWs1UX5/Y4/phMMQjvsdyJb9oGD6vPIGIN4A4/eYf8
         A/bkBCLLnjQzUQnnls+g5Z7QgRB/PymexSMzs=
MIME-Version: 1.0
Date: Tue, 18 May 2010 22:35:30 -0700
Message-ID: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>
Subject: [PATCH] Prevent reserving RAM in the region already reserved by BIOS
From: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
To: yinghai@kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Cc: Me <mathieu.rondonneau@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does it make sense to prevent looking for stolen RAM below the ISA section.


Signed-off-by: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
---
 arch/x86/kernel/e820.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..322c9c3 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1156,6 +1156,8 @@ void __init e820_reserve_resources_late(void)
                        end = MAX_RESOURCE_SIZE;
                if (start >= end)
                        continue;
+               if (end < ISA_START_ADDRESS)
+                       continue;
                printk(KERN_DEBUG "reserve RAM buffer: %016llx - %016llx ",
                               start, end);
                reserve_region_with_split(&iomem_resource, start, end,
-- 
1.6.3.3
