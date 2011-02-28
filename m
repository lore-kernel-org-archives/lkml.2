Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1B1GkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:40:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1B1GkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:40:11 -0500
Date: Mon, 28 Feb 2011 17:40:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the bkl-config tree with the tty tree
Message-Id: <20110228174007.b6faf01e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-config tree got a conflict in
drivers/staging/Kconfig between commits
4a6514e6d096716fb7bedf238efaaca877e2a7e8 ("tty: move obsolete and broken
tty drivers to drivers/staging/tty/") and
4c37705877e74c02c968735c2eee0f84914cf557 ("tty: move obsolete and broken
generic_serial drivers to drivers/staging/generic_serial/") from the tty
tree and commit a3ba01b63468c925518da2da0ac3be11358f60cb ("BKL: move
CONFIG_BKL to staging") from the bkl-config tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/Kconfig
index fc751e3,5adf537..0000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -41,10 -41,17 +41,21 @@@ config STAGING_EXCLUDE_BUIL
  
  if !STAGING_EXCLUDE_BUILD
  
+ config BKL
+ 	bool "Include drivers that depend on the Big Kernel Lock" if (SMP || PREEMPT)
+ 	default !(SMP || PREEMPT)
+ 	help
+ 	  This is the traditional lock that is used in old code instead
+ 	  of proper locking. All drivers that use the BKL should depend
+ 	  on this symbol.
+ 	  A small number of drivers still require this. All drivers that
+ 	  use the BKL should be changed to a better serialisation method
+ 	  or they will be removed in 2.6.39.
+ 
 +source "drivers/staging/tty/Kconfig"
 +
 +source "drivers/staging/generic_serial/Kconfig"
 +
  source "drivers/staging/et131x/Kconfig"
  
  source "drivers/staging/slicoss/Kconfig"
