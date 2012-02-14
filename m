Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207Ab2BNVHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:07:23 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59341 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757241Ab2BNVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:07:22 -0500
Message-ID: <4F3ACCE2.6040200@xenotime.net>
Date: Tue, 14 Feb 2012 13:06:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-dev-en@lists.sourceforge.jp, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] security: TOMOYO should clean policy files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

TOMOYO creates some empty/default policy files during build.
It should remove them during 'make clean'.

I noticed that they were not being removed because the
"Creating ..." messages always occurred a maximum of one time
during 25 randconfig builds, so it was sometimes using the
files from a previous build (which is not a problem, but
still, 'make clean' should remove them).

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Kentaro Takeda <takedakn@nttdata.co.jp>
Cc:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:	tomoyo-dev-en@lists.sourceforge.jp
---
 security/tomoyo/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20120214.orig/security/tomoyo/Makefile
+++ linux-next-20120214/security/tomoyo/Makefile
@@ -46,3 +46,5 @@ $(obj)/builtin-policy.h: $(obj)/policy/p
 	@mv $@.tmp $@
 
 $(obj)/common.o: $(obj)/builtin-policy.h
+
+clean-dirs := $(objtree)/security/tomoyo/policy/
