Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab2AJRKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:10:13 -0500
Received: from relay02ant.iops.be ([212.53.4.35]:47773 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab2AJRKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:10:04 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jan 2012 12:10:04 EST
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: x86-64: Make uaccess_err unsigned
Date: Tue, 10 Jan 2012 17:03:30 +0000
Message-ID: <3955556.vbKFqerH5U@asus>
User-Agent: KMail/4.7.2 (Linux/3.1.8+; KDE/4.7.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 4fc3490114bb159bd4fff1b3c96f4320fe6fb08f uaccess_err
was changed from an int into a one bit bitfield. The values that
can be represented by a one bit bitfield are 0 and -1. Since
only values 0 and 1 are ever assigned to uaccess_err, make that
bitfield unsigned. Also change the one bit bitfield sig_on_uaccess
from signed into unsigned. This patch makes two annoying sparse
warnings about signed one bit bitfields disappear.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 7404715..ea3b445 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,8 +40,8 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
-	int			sig_on_uaccess_error:1;
-	int			uaccess_err:1;	/* uaccess failed */
+	unsigned		sig_on_uaccess_error:1;
+	unsigned		uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
-- 
1.7.7


