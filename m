Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0EXWkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:40:55 -0400
Received: from kroah.org ([198.145.64.141]:42363 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab0EXWiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:21 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:17 2010
Message-Id: <20100524223017.043009998@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:28:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [13/24] tty: release_one_tty() forgets to put pids
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 6da8d866d0d39e9509ff826660f6a86a6757c966 upstream.

release_one_tty(tty) can be called when tty still has a reference
to pgrp/session. In this case we leak the pid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1893,6 +1893,8 @@ static void release_one_tty(struct tty_s
 	list_del_init(&tty->tty_files);
 	file_list_unlock();
 
+	put_pid(tty->pgrp);
+	put_pid(tty->session);
 	free_tty_struct(tty);
 }
 


