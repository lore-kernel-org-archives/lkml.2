Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0F3VUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:20:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38622 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab0F3VUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ThSAiTPh98f9bfqClHmYwp42J05mtlnR0PMxd9cbcoNcHF+2XREt8eU5Lw2L76CU8+
         62ty21AdQb5nzOF+Vh1J9DpUGbBS39oMrntqo2oKqHFxJPjvDzum4JHUlMtidMj4gNFb
         0FuAVpm3ViuZBALmSBKlzj4KkaT9UQFvqSBK0=
Message-ID: <4C2BB52A.7070404@gmail.com>
Date: Wed, 30 Jun 2010 14:20:42 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]kernel.h Fix #warning message web address.
References: <1277840244-3436-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1006301147490.13809@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hehe, ugly. How about making it a single string? GCC preprocessor
> documentation suggests the same anyway ...
>
> 	Neither `#error' nor `#warning' macro-expands its argument.
> 	Internal whitespace sequences are each replaced with a single space.
> 	The line must consist of complete tokens.  It is wisest to make the
> 	argument of these directives be a single string constant; this avoids
> 	problems with apostrophes and the like.
>

o.k. jiri, here is what I came up with, after re-reading and looking at 
other in the kernel(below).



 From 45f24db45faa06aad01cfc62ff4b475380e5cb11 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Wed, 30 Jun 2010 14:06:18 -0700
Subject: [PATCH]kernel.h Fix #warning message according to the GCC 
preprocessor docs.

received this #warning from a simple printk program and noticed the web
address is not showing up:
  gcc printk.c -o printk
In file included from printk.c:3:
include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel 
headers from user space, see http:

after the changes the warning should just say:
#warning Attempt to use kernel headers from user space!

  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
  include/linux/kernel.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..b542961 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);

  #ifndef __EXPORTED_HEADERS__
  #ifndef __KERNEL__
-#warning Attempt to use kernel headers from user space, see 
http://kernelnewbies.org/KernelHeaders
+#warning Attempt to use kernel headers from user space!
  #endif /* __KERNEL__ */
  #endif /* __EXPORTED_HEADERS__ */

-- 
1.7.1.rc1.21.gf3bd6


now I'm wondering if there should be a lead to the documentation with 
this web address(seems grep is not finding anything that I might be able 
to use).or just leave as is, and let people connect-the-dots!!

let me know..

Justin P. Mattock
