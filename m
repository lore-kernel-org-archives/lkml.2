Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1JWGhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:37:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab1JWGeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:14 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:38 2011
Message-Id: <20111023062538.102413039@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:33 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [05/27] Avoid using variable-length arrays in kernel/sys.c
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a84a79e4d369a73c0130b5858199e949432da4c6 upstream.

The size is always valid, but variable-length arrays generate worse code
for no good reason (unless the function happens to be inlined and the
compiler sees the length for the simple constant it is).

Also, there seems to be some code generation problem on POWER, where
Henrik Bakken reports that register r28 can get corrupted under some
subtle circumstances (interrupt happening at the wrong time?).  That all
indicates some seriously broken compiler issues, but since variable
length arrays are bad regardless, there's little point in trying to
chase it down.

"Just don't do that, then".

Reported-by: Henrik Grindal Bakken <henribak@cisco.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1135,7 +1135,7 @@ DECLARE_RWSEM(uts_sem);
 static int override_release(char __user *release, int len)
 {
 	int ret = 0;
-	char buf[len];
+	char buf[65];
 
 	if (current->personality & UNAME26) {
 		char *rest = UTS_RELEASE;


