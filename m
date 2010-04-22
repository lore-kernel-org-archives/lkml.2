Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0DVU2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:28:19 -0400
Received: from kroah.org ([198.145.64.141]:59538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab0DVT74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:56 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.611295975@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [029/139] tty: release_one_tty() forgets to put pids
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1423,6 +1423,8 @@ static void release_one_tty(struct work_
 	list_del_init(&tty->tty_files);
 	file_list_unlock();
 
+	put_pid(tty->pgrp);
+	put_pid(tty->session);
 	free_tty_struct(tty);
 }
 


