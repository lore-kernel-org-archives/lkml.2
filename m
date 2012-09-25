Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2IYMI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:08:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63451 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2IYMI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:08:56 -0400
Date: Tue, 25 Sep 2012 16:08:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Salter <msalter@redhat.com>, Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH] prctl: Use access_ok instead of TASK_SIZE in prctl_set_mm
Message-ID: <20120925120852.GH14490@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric pointed that better to use access_ok instead
of TASK_SIZE for testing if address is allowed for
use.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Mark Salter <msalter@redhat.com>
CC: Kees Cook <keescook@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
---
 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1865,7 +1865,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
 
-	if (addr >= TASK_SIZE || addr < mmap_min_addr)
+	if (!access_ok(VERIFY_READ, addr, sizeof(addr)) || addr < mmap_min_addr)
 		return -EINVAL;
 
 	error = -EINVAL;
