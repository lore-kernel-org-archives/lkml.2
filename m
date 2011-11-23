Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab1KWE2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:28:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35384 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1KWE23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:28:29 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
Date: Tue, 22 Nov 2011 23:28:24 -0500
Message-Id: <7187C142-99F1-4A96-9BE6-650B10C9B22D@gmail.com>
Cc: Joerg Reuter <jreuter@yaina.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ax25_setsockopt() misses several upper-bound checks on the
user-controlled value.


Reported-by: Fan Long <longfancn@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 net/ax25/af_ax25.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index e7c69f4..be6a8cf 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -571,7 +571,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T1:
-		if (opt < 1) {
+		if (opt < 1 || opt > 30) {
 			res = -EINVAL;
 			break;
 		}
@@ -580,7 +580,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T2:
-		if (opt < 1) {
+		if (opt < 1 || opt > 20) {
 			res = -EINVAL;
 			break;
 		}
@@ -596,7 +596,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T3:
-		if (opt < 1) {
+		if (opt < 0 || opt > 3600) {
 			res = -EINVAL;
 			break;
 		}
@@ -604,7 +604,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_IDLE:
-		if (opt < 0) {
+		if (opt < 0 || opt > 65535) {
 			res = -EINVAL;
 			break;
 		}
-- 
1.7.5.4

