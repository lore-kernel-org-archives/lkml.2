Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0IJJEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:04:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab0IJJEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:04:43 -0400
Message-ID: <4C89F47D.20309@kernel.org>
Date: Fri, 10 Sep 2010 11:03:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] percpu: update comments to reflect that percpu allocations
 are always zero-filled
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com>	<1284040322.2589.174.camel@edumazet-laptop>	<AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com>	<1284106566.402.26.camel@laptop>	<4C89EF37.5080803@kernel.org> <AANLkTi=7PJPCwrnK+4ejX7RHC-sautVgK-_+kpoT27k5@mail.gmail.com>
In-Reply-To: <AANLkTi=7PJPCwrnK+4ejX7RHC-sautVgK-_+kpoT27k5@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 09:03:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephane Eranian <eranian@google.com>
---
 mm/percpu.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 0cd4bf6..12dea33 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -826,8 +826,8 @@ fail_unlock_mutex:
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  *
- * Allocate percpu area of @size bytes aligned at @align.  Might
- * sleep.  Might trigger writeouts.
+ * Allocate zero-filled percpu area of @size bytes aligned at @align.
+ * Might sleep.  Might trigger writeouts.
  *
  * CONTEXT:
  * Does GFP_KERNEL allocation.
@@ -846,9 +846,10 @@ EXPORT_SYMBOL_GPL(__alloc_percpu);
  * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  *
- * Allocate percpu area of @size bytes aligned at @align from reserved
- * percpu area if arch has set it up; otherwise, allocation is served
- * from the same dynamic area.  Might sleep.  Might trigger writeouts.
+ * Allocate zero-filled percpu area of @size bytes aligned at @align
+ * from reserved percpu area if arch has set it up; otherwise,
+ * allocation is served from the same dynamic area.  Might sleep.
+ * Might trigger writeouts.
  *
  * CONTEXT:
  * Does GFP_KERNEL allocation.
-- 
1.7.1

