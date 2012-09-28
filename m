Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab2I1S4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab2I1S4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christopher Brannon <chris@the-brannons.com>
Subject: [ 059/262] Staging: speakup: fix an improperly-declared variable.
Date: Fri, 28 Sep 2012 11:49:48 -0700
Message-Id: <20120928183004.859858807@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


