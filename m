Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1DRMOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:14:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42426 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRMOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:14:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH 0/3] convert mm->cpu_vm_mask into cpumask_var_t
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110418211455.9359.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 18 Apr 2011 21:14:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, I and Hugh discussed about size of mm_struct. And then, I decided
to spend some time to diet it.

Unfortunately, We don't finished to convert cpumask_size() into full
nr_cpu_ids-ism. then, We can't get full benefit of cpumask_var_t yet.
However I expect it will be solved in this or next year.


KOSAKI Motohiro (3):
  mn10300: replace mm->cpu_vm_mask with mm_cpumask
  tile: replace mm->cpu_vm_mask with mm_cpumask()
  mm: convert mm->cpu_vm_cpumask into cpumask_var_t

 Documentation/cachetlb.txt          |    2 +-
 arch/mn10300/kernel/smp.c           |    2 +-
 arch/mn10300/mm/tlb-smp.c           |    6 ++--
 arch/tile/include/asm/mmu_context.h |    4 +-
 arch/tile/kernel/tlb.c              |   12 +++++-----
 include/linux/mm_types.h            |    9 +++++--
 include/linux/sched.h               |    1 +
 init/main.c                         |    2 +
 kernel/fork.c                       |   37 ++++++++++++++++++++++++++++++++--
 mm/init-mm.c                        |    1 -
 10 files changed, 56 insertions(+), 20 deletions(-)

-- 
1.7.3.1



