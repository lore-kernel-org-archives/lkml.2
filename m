Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2FTSWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2FTSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:10 -0400
Message-Id: <20120620173023.095194599@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seiji Aguchi <seiji.aguchi@hds.com>,
        Don Zickus <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Tony Luck <tony.luck@intel.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 25/61] kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Aguchi <seiji.aguchi@hds.com>

commit 62be73eafaa045d3233337303fb140f7f8a61135 upstream.

This patch moves kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop(),
to serialize the crash-logging process via smp_send_stop() and to
thus retrieve a more stable crash image of all CPUs stopped.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: dle-develop@lists.sourceforge.net <dle-develop@lists.sourceforge.net>
Cc: Satoru Moriya <satoru.moriya@hds.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: a.p.zijlstra@chello.nl <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5C4C569E8A4B9B42A84A977CF070A35B2E4D7A5CE2@USINDEVS01.corp.hds.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/panic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -108,8 +108,6 @@ void panic(const char *fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
-
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
@@ -117,6 +115,8 @@ void panic(const char *fmt, ...)
 	 */
 	smp_send_stop();
 
+	kmsg_dump(KMSG_DUMP_PANIC);
+
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
 	bust_spinlocks(0);


