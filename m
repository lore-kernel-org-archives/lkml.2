Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2IEQhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:37:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51429 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2IEQhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:37:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] uml: fix compile error in deliver_alarm()
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Martin =?utf-8?Q?P=C3=A4rtel?= <martin.partel@gmail.com>
Date: Wed, 05 Sep 2012 18:38:50 +0200
Message-ID: <87harca0h1.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix the following compile error on UML.

arch/um/os-Linux/time.c: In function 'deliver_alarm':
arch/um/os-Linux/time.c:117:3: error: too few arguments to function 'alarm_handler'
arch/um/os-Linux/internal.h:1:6: note: declared here

The error was introduced by commit d3c1cfcd (um: pass siginfo to guest
process) in 3.6-rc1.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Martin Pärtel <martin.partel@gmail.com>
---
 arch/um/os-Linux/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.orig/arch/um/os-Linux/time.c	2012-09-05 17:18:27.000000000 +0200
+++ linux-2.6/arch/um/os-Linux/time.c	2012-09-05 18:34:35.000000000 +0200
@@ -114,7 +114,7 @@ static void deliver_alarm(void)
 	skew += this_tick - last_tick;
 
 	while (skew >= one_tick) {
-		alarm_handler(SIGVTALRM, NULL);
+		alarm_handler(SIGVTALRM, NULL, NULL);
 		skew -= one_tick;
 	}
 
