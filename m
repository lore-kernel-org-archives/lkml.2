Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0IXRTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:19:13 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:43579 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750779Ab0IXRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:19:12 -0400
Subject: [PATCH] x86: return proper error code
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 13:19:08 -0400
Message-ID: <1285348748.3031.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: return -ENOMEM instead of -1 when returning on memory allocation errors in add_kmmio_fault_page()

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index e5d5e2c..36a4347 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -370,7 +370,7 @@ static int add_kmmio_fault_page(unsigned long page)
 
 	f = kzalloc(sizeof(*f), GFP_ATOMIC);
 	if (!f)
-		return -1;
+		return -ENOMEM;
 
 	f->count = 1;
 	f->page = page;
-- 
1.7.0.4



