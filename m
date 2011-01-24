Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1AXQzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:55:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36353 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1AXQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GEmvMrZI/yb6B8KcinTY8e72mzJJ8RxOVr5ZA4Tc5MDW9DHJ9EHaLlikF9iGb9bbLa
         LaoFdDtbGybpn/w4kreasnWIOWsy3g1j50uucSpkQHqTWWcKPqGlVcYoV8P3vSJmCuAQ
         xVGu0zU6lJdqF4rZqZk6H2y5fo3jezjPBf5dw=
Date: Mon, 24 Jan 2011 17:54:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nozomi: don't use flush_scheduled_work()
Message-ID: <20110124165448.GG27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() in tty_exit() doesn't seem to target any
specific work.  If it was to flush work items used in tty generic
layer, they're already flushed properly during tty release.

flush_scheduled_work() is going away.  Remove the seemingly redundant
usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |    2 --
 1 file changed, 2 deletions(-)

Index: work/drivers/char/nozomi.c
===================================================================
--- work.orig/drivers/char/nozomi.c
+++ work/drivers/char/nozomi.c
@@ -1514,8 +1514,6 @@ static void __devexit tty_exit(struct no
 
 	DBG1(" ");
 
-	flush_scheduled_work();
-
 	for (i = 0; i < MAX_PORT; ++i) {
 		struct tty_struct *tty = tty_port_tty_get(&dc->port[i].port);
 		if (tty && list_empty(&tty->hangup_work.entry))
