Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0LLXp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44579 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0LLXpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:04 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: samuel@sortiz.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [8/223] irda: Fix parameter extraction stack overflow
Message-Id: <20101212234503.305A4B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Samuel Ortiz <samuel@sortiz.org>

commit efc463eb508798da4243625b08c7396462cabf9f upstream.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/irda/parameters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/net/irda/parameters.c
===================================================================
--- linux.orig/net/irda/parameters.c
+++ linux/net/irda/parameters.c
@@ -298,6 +298,8 @@ static int irda_extract_string(void *sel
 
 	p.pi = pi;     /* In case handler needs to know */
 	p.pl = buf[1]; /* Extract length of value */
+	if (p.pl > 32)
+		p.pl = 32;
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __func__,
 		   p.pi, p.pl);
@@ -318,7 +320,7 @@ static int irda_extract_string(void *sel
 		   (__u8) str[0], (__u8) str[1]);
 
 	/* Null terminate string */
-	str[p.pl+1] = '\0';
+	str[p.pl] = '\0';
 
 	p.pv.c = str; /* Handler will need to take a copy */
 
