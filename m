Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2APHzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:55:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2APHzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:55:13 -0500
Message-ID: <4F13D873.4070808@cn.fujitsu.com>
Date: Mon, 16 Jan 2012 15:57:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Cong Wang <amwang@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Davidlohr Bueso <dave@gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Wang YanQing <udknight@gmail.com>
Subject: [PATCH] menuconfig: fix a regression when canceling the prompt dialog
 at exit
References: <4F13CB49.8030004@cn.fujitsu.com> <1326698421.4151.4.camel@cr0> <4F13D216.3060705@cn.fujitsu.com>
In-Reply-To: <4F13D216.3060705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 15:54:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 15:54:05,
	Serialize complete at 2012-01-16 15:54:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes a bug, while introducing a new one..

commit 7203ddbd4be9720649e47d756a001e0c7d7f8ae2
Author: Wang YanQing <udknight@gmail.com>
Date:   Thu Jan 12 11:31:32 2012 +0800

    menuconfig: let make not report error when not save configuration

Pressing ESC should cancel the yes/no dialog and return back to
the main menu, but not exit from menuconfig.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/mconf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 86cd1ea..2c6286c 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -830,7 +830,8 @@ static int handle_exit(void)
 		fprintf(stderr, _("\n\n"
 				  "Your configuration changes were NOT saved."
 				  "\n\n"));
-		res = 0;
+		if (res != KEY_ESC)
+			res = 0;
 	}
 
 	return res;
-- 
1.7.3.1
