Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0IXVsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:48:16 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:49965 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0IXVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=tsILRf
	zAMzyd8q5VNAK//1PNZslWCHqtL6m1mCKsh3B3DKSNtah8+eOvg2VvE/Gx8ioDit
	nNDh0sK5+BwQl541FgpYmKfzk69TIZi64TRhnk4xFCcHeOmEJyGOke27QacRusou
	67BtoJjHMdKrdmCtCXGV++Rv2EE7S6m8Qe+FI=
Subject: [PATCH] fix blk-exec.c compile error: always define
 'sysctl_hung_task_timeout_secs' (resend)
From: Mark Lord <mlord@pobox.com>
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@lst.de,
        IDE/ATA development list <linux-ide@vger.kernel.org>
In-Reply-To: <20100924202106.GC7145@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <4C9CEFD6.3000106@kernel.dk>  <20100924202106.GC7145@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Real-Time Remedies Inc.
Date: Fri, 24 Sep 2010 17:46:37 -0400
Message-ID: <1285364797.12723.1.camel@corey>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 6C74DC14-C825-11DF-A0EB-030CEE7EF46B-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that 'sysctl_hung_task_timeout_secs' is defined
even when CONFIG_DETECT_HUNG_TASK is not set.
This way we can safely reference it without need for
ifdefs in the code elsewhere.  eg. in block/blk-exec.c

Signed-off-by: Mark Lord <mlord@pobox.com>

(Resending from a repaired email client.)
Jens: my apologies for not catching this this earlier.

--- a/include/linux/sched.h	2010-09-20 19:56:53.000000000 -0400
+++ b/include/linux/sched.h	2010-09-24 17:22:01.707291995 -0400
@@ -336,6 +336,9 @@
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 void __user *buffer,
 					 size_t *lenp, loff_t *ppos);
+#else
+/* Avoid need for ifdefs elsewhere in the code */
+enum { sysctl_hung_task_timeout_secs = 0 };
 #endif
 
 /* Attach to any functions which should be ignored in wchan output. */



