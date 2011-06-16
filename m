Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1FPA42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:56:28 -0400
Received: from outmail004.snc4.facebook.com ([66.220.144.136]:37426 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590Ab1FPA41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:56:27 -0400
Message-ID: <4DF954E3.6040701@fb.com>
Date: Wed, 15 Jun 2011 17:57:07 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/3] atomic: use <linux/atomic.h>
References: <1307381251-15729-1-git-send-email-asharma@fb.com> <20110615163115.773d072e.akpm@linux-foundation.org>
In-Reply-To: <20110615163115.773d072e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/11 4:31 PM, Andrew Morton wrote:
>
> I didn't merge patch #3.  With patches 1&  2 applied, i386 allnoconfig:
>

Dropping patch#3 is fine, since Eric removed the primitive. For this 
problem, I'm testing a patch along the lines of:

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -318,5 +318,4 @@ static inline void atomic_or_long(unsigned long *v1, 
unsigned long v2)
  # include "atomic64_64.h"
  #endif

-#include <asm-generic/atomic-long.h>
  #endif /* _ASM_X86_ATOMIC_H */

--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -85,4 +85,8 @@ static inline void atomic_or(int i, atomic_t *v)
  }
  #endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */

+#include <asm-generic/atomic-long.h>
+#ifdef CONFIG_GENERIC_ATOMIC64
+#include <asm-generic/atomic64.h>
+#endif
  #endif /* _LINUX_ATOMIC_H */

.. repeated for all other archs.

  -Arun
