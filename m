Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0KIQhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:37:24 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:38620 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751222Ab0KIQhX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:37:23 -0500
Subject: [PATCH] net: replace min with min_t in pktgen_if_write
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: David Miller <davem@davemloft.net>,
        Robert Olsson <robert.olsson@its.uu.se>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 13:37:13 -0300
Message-ID: <1289320633.2260.12.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

This addresses the following compiler (gcc 4.4.5) warning:

  CC [M]  net/core/pktgen.o
net/core/pktgen.c: In function ‘pktgen_if_write’:
net/core/pktgen.c:890: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 net/core/pktgen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fbce4b0..1992cd0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -887,7 +887,7 @@ static ssize_t pktgen_if_write(struct file *file,
 	i += len;
 
 	if (debug) {
-		size_t copy = min(count, 1023);
+		size_t copy = min_t(size_t, count, 1023);
 		char tb[copy + 1];
 		if (copy_from_user(tb, user_buffer, copy))
 			return -EFAULT;
-- 
1.7.1



