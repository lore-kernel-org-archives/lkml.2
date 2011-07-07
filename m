Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1GGC1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:27:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1GGC1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:27:18 -0400
MIME-Version: 1.0
Date: Wed, 6 Jul 2011 19:19:59 -0700
X-Google-Sender-Auth: uB6JG_mUUzl6wcWE6XIKqegTilg
Message-ID: <CAN_5kQDTweB2GLvwgjN+BQuqnhFUp+MOcQr=ZW=8C6XSsC8XtA@mail.gmail.com>
Subject: [PATCH] remove unnecessary cache flush on v6 copypage
From: heechul Yun <heechul@illinois.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: mm: remove unnecessary cache flush on v6 copypage

Signed-off-by: Heechul Yun <heechul@illinois.edu>
--
arch/arm/mm/copypage-v6.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index bdba6c6..63cca00 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -41,7 +41,6 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
       kfrom = kmap_atomic(from, KM_USER0);
       kto = kmap_atomic(to, KM_USER1);
       copy_page(kto, kfrom);
-       __cpuc_flush_dcache_area(kto, PAGE_SIZE);
       kunmap_atomic(kto, KM_USER1);
       kunmap_atomic(kfrom, KM_USER0);
 }

--

Heechul
