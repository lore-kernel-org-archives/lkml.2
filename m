Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0IXVlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:41:16 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:45384 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0IXVlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type; q=dns; s=sasl; b=JO6UMO7lQaQ8jR3/TCLa7nKKVUBwibA1
	2o/04jQw+osy/qJfN1QxXGqn3fEXvANFm5yn2fzfQVl/hTk8jGgqenh/NSiin6x7
	R6g/EDfd95er3stOj0F9KYQ9blnBUzqy6lG6ktHhloFyfCSFK7K7IS7e2UxDE5f5
	b9wCSJ+wKj8=
Message-ID: <4C9D1AEF.6090307@pobox.com>
Date: Fri, 24 Sep 2010 17:41:03 -0400
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9)
 Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, hch@lst.de,
        IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <4C9CEFD6.3000106@kernel.dk> <20100924202106.GC7145@redhat.com>
In-Reply-To: <20100924202106.GC7145@redhat.com>
Content-Type: multipart/mixed; boundary="------------060005010505000109070903"
X-Pobox-Relay-ID: 7141E274-C824-11DF-BBA1-030CEE7EF46B-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060005010505000109070903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ensure that 'sysctl_hung_task_timeout_secs' is defined
even when CONFIG_DETECT_HUNG_TASK is not set.
This way we can safely reference it without need for
#ifdefs elsewhere in the code.  eg. in block/blk-exec.c

Signed-off-by: Mark Lord <mlord@pobox.com>

Jens: use the attachment.  My email client is having a fit today.

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

--------------060005010505000109070903
Content-Type: text/x-patch;
 name="fix_blk_exec_compile_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix_blk_exec_compile_error.patch"

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

--------------060005010505000109070903--
