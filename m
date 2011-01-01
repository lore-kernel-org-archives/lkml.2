Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1AAUcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 15:32:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33520 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1AAUcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 15:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fJhuCpNWmLmkSW51gJBUqOR0t9+5n0QSEhKFhYNgFI2vKYF95DFFi1ibvNr5OyY2Xf
         svbyajXhbVntjy7cLxBggscyv/1TqtiZPrVd5I1ZqVpPbCOeOIV/g0R2ugukmzdOJK2J
         gfL7F70cI1CgGVL8C1GaQ0t+/NwjfGxzD/DTA=
Message-ID: <4D1F8F5D.1020705@gmail.com>
Date: Sat, 01 Jan 2011 21:32:29 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, khilman@deeprootsystems.com
Subject: [PATCH] davinci: tests for suitable timings in davinci_aemif_setup_timing()
 fail
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have to be signed or the tests for suitable timings always fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/mach-davinci/aemif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This was not compile tested.

diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index 9c3f500..1ce70a9 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -90,7 +90,7 @@ int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
 					void __iomem *base, unsigned cs)
 {
 	unsigned set, val;
-	unsigned ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
+	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
 	unsigned offset = A1CR_OFFSET + cs * 4;
 	struct clk *aemif_clk;
 	unsigned long clkrate;
