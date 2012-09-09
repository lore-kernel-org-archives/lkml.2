Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2IIPEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:04:09 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:42361 "EHLO
	homiemail-a14.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753954Ab2IIPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:04:07 -0400
Message-ID: <1347203038.3288.1.camel@offbook>
Subject: [PATCH] lib: gcd: prevent possible div by 0
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Date: Sun, 09 Sep 2012 17:03:58 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account for properties when a and/or b are 0:
gcd(0, 0) = 0
gcd(a, 0) = a
gcd(0, b) = b

Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 lib/gcd.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/gcd.c b/lib/gcd.c
index cce4f3c..7e163c6 100644
--- a/lib/gcd.c
+++ b/lib/gcd.c
@@ -7,6 +7,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
 {
 	unsigned long r;
 
+	if (!a || !b)
+		return a | b;
+
 	if (a < b)
 		swap(a, b);
 	while ((r = a % b) != 0) {
-- 
1.7.9.5



