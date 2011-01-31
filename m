Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1AaBqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 20:46:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46666 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1AaBqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 20:46:38 -0500
Date: Mon, 31 Jan 2011 12:46:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Torben Hohn <torbenh@gmx.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the tty.current tree with Linus' tree
Message-Id: <20110131124633.3f49a8f9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty.current tree got a conflict in
drivers/tty/tty_io.c between commit
ac751efa6a0d70f2c9daef5c7e3a92270f5c2dff ("console: rename
acquire/release_console_sem() to console_lock/unlock()") from Linus' tree
and commit a2a6a822adc2a91c677cb60e9bc6ffe26fa90e9f ("tty: use
for_each_console() and WARN() on sysfs failures") from the tty.current
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/tty_io.c
index 6158eae,dae6fc9..0000000
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@@ -3256,8 -3256,8 +3256,8 @@@ static ssize_t show_cons_active(struct 
  	struct console *c;
  	ssize_t count = 0;
  
 -	acquire_console_sem();
 +	console_lock();
- 	for (c = console_drivers; c; c = c->next) {
+ 	for_each_console(c) {
  		if (!c->device)
  			continue;
  		if (!c->write)
