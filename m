Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2IJOf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:35:27 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:39721 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751470Ab2IJOfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:35:23 -0400
Message-ID: <1347287719.2561.14.camel@offbook>
Subject: [PATCH v2] lib: gcd: prevent possible div by 0
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Mon, 10 Sep 2012 16:35:19 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account for all properties when a and/or b are 0:
gcd(0, 0) = 0
gcd(a, 0) = a
gcd(0, b) = b

Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
V2: simplified checking with b = 0 (Eric)

 lib/gcd.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/gcd.c b/lib/gcd.c
index cce4f3c..3657f12 100644
--- a/lib/gcd.c
+++ b/lib/gcd.c
@@ -9,6 +9,9 @@ unsigned long gcd(unsigned long a, unsigned long b)
 
 	if (a < b)
 		swap(a, b);
+
+	if (!b)
+		return a;
 	while ((r = a % b) != 0) {
 		a = b;
 		b = r;
-- 
1.7.9.5



