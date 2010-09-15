Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0IOD0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 23:26:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46405 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IOD0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 23:26:48 -0400
Date: Wed, 15 Sep 2010 13:26:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the bkl-llseek tree with the rr tree
Message-Id: <20100915132646.4aef58f8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
drivers/char/virtio_console.c between commit
a0e1acd65fa6c2da3b039a67ac30cc3b73466c37 ("virtio: console: Send SIGIO to
processes that request it for host events") from the rr tree and commit
7f09912dd2169ca9ce56c5e3428c7b4c5e92e727 ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/virtio_console.c
index f7adfd3,524907b..0000000
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@@ -824,7 -728,7 +824,8 @@@ static const struct file_operations por
  	.write = port_fops_write,
  	.poll  = port_fops_poll,
  	.release = port_fops_release,
 +	.fasync = port_fops_fasync,
+ 	.llseek = noop_llseek,/* read and write both use no f_pos */
  };
  
  /*
