Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0I3NHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:07:45 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53532 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0I3NHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:07:43 -0400
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 30 Sep 2010 22:07:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I was browsing do_execve() and noticed that do_execve() will return positive
return value if "struct linux_binfmt"->load_binary() returned positive return
value. So far, all in-tree "struct linux_binfmt" users seem to return 0 on
success and negative return value on failure. But search_binary_handler()
itself is designed to allow positive return value on successful execve().

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1413,6 +1413,9 @@ int do_execve(const char * filename,
 	free_bprm(bprm);
 	if (displaced)
 		put_files_struct(displaced);
+	/* Just for testing. */
+	if (!retval)
+		retval = 1;
 	return retval;
 
 out:

With a patch above (on x86 CentOS 5.5 with 2.6.36-rc6 kernel),
a few programs failed to work properly.

  udevd-event[$PID]: run_program: '$PROGRAM' abnormal exit

Is it legal to return positive value when do_execve() succeeds?

Regards.
