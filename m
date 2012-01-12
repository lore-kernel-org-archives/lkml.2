Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2ALDcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 22:32:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45246 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2ALDcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 22:32:12 -0500
Date: Thu, 12 Jan 2012 11:31:32 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        lacombar@gmail.com, dave@gnu.org
Subject: [PATCH] scripts:kconfig:mconf.c: let make not report error when not
 save configuration
Message-ID: <20120112033132.GA13752@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>, mmarek@suse.cz,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	lacombar@gmail.com, dave@gnu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find every time when I choice the 'NO' button at the dialog
which let me choice whether to save the configuration before exit
menuconfig, it always report the blow:

" GEN     /mnt/sda7/home/build/test/Makefile
  HOSTCC  scripts/kconfig/mconf.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf Kconfig

Your configuration changes were NOT saved.

make[2]: *** [menuconfig] Error 1
make[1]: *** [menuconfig] Error 2
make: *** [sub-make] Error 2 "

This patch repair it.

Thanks!

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/mconf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 19e200d..86cd1ea 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -830,6 +830,7 @@ static int handle_exit(void)
 		fprintf(stderr, _("\n\n"
 				  "Your configuration changes were NOT saved."
 				  "\n\n"));
+		res = 0;
 	}
 
 	return res;
-- 
1.7.3.4

