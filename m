Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162047Ab2GLWmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:42:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161988Ab2GLWmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 111/187] x86, compat: Use test_thread_flag(TIF_IA32) in compat signal delivery
Date: Thu, 12 Jul 2012 15:34:27 -0700
Message-Id: <20120712191532.664030670@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 0b91f45b23cb73ce11acdc3cf4c6efd4441e3b3e upstream.

Signal delivery compat path may not have the 'TS_COMPAT' flag (that
flag indicates how we entered the kernel).  So use
test_thread_flag(TIF_IA32) instead of is_ia32_task(): one of the
functions of TIF_IA32 is just what kind of signal frame we want.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/ia32/ia32_signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -38,7 +38,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
-	bool ia32 = is_ia32_task();
+	bool ia32 = test_thread_flag(TIF_IA32);
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;


