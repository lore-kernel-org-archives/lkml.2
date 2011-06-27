Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1F0Ug4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:36:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26003 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1F0UfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:35:20 -0400
Date: Mon, 27 Jun 2011 22:26:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Rik Faith <faith@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH][Resend] audit: Always follow va_copy() with va_end()
Message-ID: <alpine.LNX.2.00.1106272223070.30245@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call to va_copy() should always be followed by a call to va_end() in the
same function. In kernel/autit.c::audit_log_vformat() this is not always
done. This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 kernel/audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

 Last submitted Dec 24 2010 with no response, so resending.

diff --git a/kernel/audit.c b/kernel/audit.c
index 9395003..67c2582 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1257,12 +1257,13 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
 		avail = audit_expand(ab,
 			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
 		if (!avail)
-			goto out;
+			goto out_va_end;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
 	}
-	va_end(args2);
 	if (len > 0)
 		skb_put(skb, len);
+out_va_end:
+	va_end(args2);
 out:
 	return;
 }
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

