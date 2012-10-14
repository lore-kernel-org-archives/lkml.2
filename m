Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2JNPGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:06:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46349 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570Ab2JNOmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:39 -0400
Message-Id: <20121014143548.098973280@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Davidlohr Bueso <dave@gnu.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 106/147] lib/gcd.c: prevent possible div by 0
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@gnu.org>

commit e96875677fb2b7cb739c5d7769824dff7260d31d upstream.

Account for all properties when a and/or b are 0:
gcd(0, 0) = 0
gcd(a, 0) = a
gcd(0, b) = b

Fixes no known problems in current kernels.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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


