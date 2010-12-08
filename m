Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab0LHBAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:50 -0500
Received: from kroah.org ([198.145.64.141]:48862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab0LHBAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:47 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:32 2010
Message-Id: <20101208005732.035977169@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Weinberger <richard@nod.at>, Pekka Enberg <penberg@kernel.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: [107/289] um: fix global timer issue when using CONFIG_NO_HZ
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 482db6df1746c4fa7d64a2441d4cb2610249c679 upstream.

This fixes a issue which was introduced by fe2cc53e ("uml: track and make
up lost ticks").

timeval_to_ns() returns long long and not int.  Due to that UML's timer
did not work properlt and caused timer freezes.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "


