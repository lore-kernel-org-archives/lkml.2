Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab1ETDgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:36:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757251Ab1ETDgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:36:36 -0400
Date: Fri, 20 May 2011 13:36:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the tip tree with the kbuild tree
Message-Id: <20110520133631.d663013a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in Makefile
between commit 28bc20dccadc ("kbuild: implement several W= levels") from
the kbuild tree and commit 85356f802225 ("kbuild/recordmcount: Add
RECORDMCOUNT_WARN to warn about mcount callers") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Makefile
index 107f7c1,a0344a8..0000000
--- a/Makefile
+++ b/Makefile
@@@ -1287,11 -1267,8 +1287,12 @@@ help
  	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
  	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
  	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 -	@echo  '  make W=1   [targets] Enable extra gcc checks'
 +	@echo  '  make W=n   [targets] Enable extra gcc checks, n=1,2,3 where'
 +	@echo  '		1: warnings which may be relevant and do not occur too often'
 +	@echo  '		2: warnings which occur quite often but may still be relevant'
 +	@echo  '		3: more obscure warnings, can most likely be ignored'
 +	@echo  '		Multiple levels can be combined with W=12 or W=123'
+ 	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
  	@echo  ''
  	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
  	@echo  'For further info see the ./README file'
