Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0HXQZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:25:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:58015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab0HXQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:25:06 -0400
Message-ID: <4C73F25D.5010205@suse.com>
Date: Tue, 24 Aug 2010 12:25:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] s390: Fix prototype for execve
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Commit d7627467b7a8dd6944885290a03a07ceb28c10eb constified the
 arguments to execve but missed the s390 prototype.

 This patch fixes it up.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 arch/s390/kernel/entry.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -42,8 +42,8 @@ long sys_clone(unsigned long newsp, unsi
 	       int __user *parent_tidptr, int __user *child_tidptr);
 long sys_vfork(void);
 void execve_tail(void);
-long sys_execve(const char __user *name, char __user * __user *argv,
-		char __user * __user *envp);
+long sys_execve(const char __user *name, const char __user *const __user *argv,
+		const char __user *const __user *envp);
 long sys_sigsuspend(int history0, int history1, old_sigset_t mask);
 long sys_sigaction(int sig, const struct old_sigaction __user *act,
 		   struct old_sigaction __user *oact);
-- 
Jeff Mahoney
SUSE Labs
