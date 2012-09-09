Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2IIXQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51148 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab2IIXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:03 -0400
Message-Id: <20120909224203.023949229@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 91/95] Staging: speakup: fix an improperly-declared variable.
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Brannon <chris@the-brannons.com>

commit 4ea418b8b2fa8a70d0fcc8231b65e67b3a72984b upstream.

A local static variable was declared as a pointer to a string
constant.  We're assigning to the underlying memory, so it
needs to be an array instead.

Signed-off-by: Christopher Brannon <chris@the-brannons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 92b34e2..40e2488 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1854,7 +1854,7 @@ static void speakup_bits(struct vc_data *vc)
 
 static int handle_goto(struct vc_data *vc, u_char type, u_char ch, u_short key)
 {
-	static u_char *goto_buf = "\0\0\0\0\0\0";
+	static u_char goto_buf[8];
 	static int num;
 	int maxlen, go_pos;
 	char *cp;


