Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2AIAx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:53:58 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57857 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2AIAx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:53:57 -0500
To: torvalds@linux-foundation.org, jj@chaosbits.net
From: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk
Date: Sun, 08 Jan 2012 19:53:51 -0500 (EST)
X-Mailer: TouchDown
X-Mailer: Zimbra 7.1.2_GA_3268 (MobileSync - TouchDown(MSRPC)/7.1.00012/)
MIME-Version: 1.0
Subject: =?utf-8?B?UkU6IFtQQVRDSF0gYXVkaXQ6IGFsd2F5cyBmb2xsb3cgdmFfY29weSgpIHdpdGggdmFfZW5kKCk=?=
Content-Type: multipart/mixed;boundary="__1326070445588TOUCHDOWN_BOUNDARY__"
Message-ID: <139540383.1157551.1326070431707.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--__1326070445588TOUCHDOWN_BOUNDARY__
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This one was committed to my audit tree which al promised to pull all of my audit tree into the vfs tree for 3.3, so if you want to take it Linus, you can add my ack as the maintainer. I'd expect to see it from Al early this week. Can't say anything about SCSI though...


-----Original Message-----
From: Jesper Juhl [jj@chaosbits.net]
Received: Sunday, 08 Jan 2012, 4:44pm
To: Linus Torvalds [torvalds@linux-foundation.org]
CC: Linux Kernel Mailing List [linux-kernel@vger.kernel.org]; Andrew Morton [akpm@linux-foundation.org]; Al Viro [viro@zeniv.linux.org.uk]; Eric Paris [eparis@redhat.com]
Subject: [PATCH] audit: always follow va_copy() with va_end()


A call to va_copy() should always be followed by a call to va_end() in the
same function.  In kernel/autit.c::audit_log_vformat() this is not always
done.  This patch makes sure va_end() is always called.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/audit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 09fae26..2c1d6ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1260,12 +1260,13 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
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
1.7.8.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


--__1326070445588TOUCHDOWN_BOUNDARY__--
