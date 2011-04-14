Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1DNRpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:37457 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab1DNRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Samuel Ortiz <samuel@sortiz.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 020/209] irda: Fix parameter extraction stack overflow
Date: Thu, 14 Apr 2011 13:40:50 -0400
Message-Id: <1302803039-9400-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <samuel@sortiz.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit efc463eb508798da4243625b08c7396462cabf9f upstream.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/parameters.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index fc1a205..71cd38c 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -298,6 +298,8 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 
 	p.pi = pi;     /* In case handler needs to know */
 	p.pl = buf[1]; /* Extract length of value */
+	if (p.pl > 32)
+		p.pl = 32;
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __func__,
 		   p.pi, p.pl);
@@ -318,7 +320,7 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 		   (__u8) str[0], (__u8) str[1]);
 
 	/* Null terminate string */
-	str[p.pl+1] = '\0';
+	str[p.pl] = '\0';
 
 	p.pv.c = str; /* Handler will need to take a copy */
 
-- 
1.7.4.4

