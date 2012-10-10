Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab2JJWxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35318 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230Ab2JJWxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:33 -0400
X-Sasl-enc: WKeAB0MwMNJ9b3sjTaEfZ7eO+dT/WK6iSMzHIRKXO3i7 1349909612
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Davidlohr Bueso <dave@gnu.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 014/133] lib/gcd.c: prevent possible div by 0
Date: Thu, 11 Oct 2012 07:50:40 +0900
Message-Id: <20121010224857.028963210@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/gcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/gcd.c
+++ b/lib/gcd.c
@@ -9,6 +9,9 @@ unsigned long gcd(unsigned long a, unsig
 
 	if (a < b)
 		swap(a, b);
+
+	if (!b)
+		return a;
 	while ((r = a % b) != 0) {
 		a = b;
 		b = r;


