Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032182Ab2I1UYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:24:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37576 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032169Ab2I1UYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christopher Brannon <chris@the-brannons.com>
Subject: [ 051/218] Staging: speakup: fix an improperly-declared variable.
Date: Fri, 28 Sep 2012 13:14:28 -0700
Message-Id: <20120928201507.376379409@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Brannon <chris@the-brannons.com>

commit 4ea418b8b2fa8a70d0fcc8231b65e67b3a72984b upstream.

A local static variable was declared as a pointer to a string
constant.  We're assigning to the underlying memory, so it
needs to be an array instead.

Signed-off-by: Christopher Brannon <chris@the-brannons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -1854,7 +1854,7 @@ static void speakup_bits(struct vc_data
 
 static int handle_goto(struct vc_data *vc, u_char type, u_char ch, u_short key)
 {
-	static u_char *goto_buf = "\0\0\0\0\0\0";
+	static u_char goto_buf[8];
 	static int num;
 	int maxlen, go_pos;
 	char *cp;


