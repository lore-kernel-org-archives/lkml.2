Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab1CWPbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:31:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1CWPbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=uXcmoikp1np46K/wazhxPmGCs/+yqBoYw/ezEcE2FixEhuEo/KcVCYtsS2N+73inNN
         liC4iBbc/hWzpa/6JOuC9ntLQ5RYI4wAAxC2r9YGHSfuzsDc1C8U0l9obciko8cwVqXl
         zkFVdACN3NTwSv7wzTpGZ420X2qAByaJa3BD8=
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 21:31:40 +0600
Message-ID: <AANLkTikh3y+is3xixKBdyHhr_cHxzPFJF729Fcvt8+Ns@mail.gmail.com>
Subject: [PATCH] x86, mpparse: Reduce memory footprint
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce extra memory footprint overhead. ret isn't used by check_slot,
gets initialized but no real use, so remove it.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f789a8..ef32d4c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -722,14 +722,12 @@ inline void __init check_irq_src(struct
mpc_intsrc *m, int *nr_m_spare) {}
 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	int ret = 0;
-
 	if (!mpc_new_phys || count <= mpc_new_length) {
 		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
 		return -1;
 	}

-	return ret;
+	return 0;
 }

 static int  __init replace_intsrc_all(struct mpc_table *mpc,
