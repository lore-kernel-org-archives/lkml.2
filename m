Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2A0XB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:01:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2A0XB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:01:57 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 0/6 v4] pagemap handles transparent hugepage
Date: Fri, 27 Jan 2012 18:02:47 -0500
Message-Id: <1327705373-29395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I rebased the patchset onto 3.3-rc1, and made some fixes on thp
optimization patch based on the feedbacks from Andrea.

Naoya Horiguchi (6):
  pagemap: avoid splitting thp when reading
  thp: optimize away unnecessary page table locking
  pagemap: export KPF_THP
  pagemap: document KPF_THP and make page-types aware of
  introduce thp_ptep_get()
  pagemap: introduce data structure for pagemap entry

 Documentation/vm/page-types.c     |    2 +
 Documentation/vm/pagemap.txt      |    4 +
 arch/x86/include/asm/pgtable.h    |    5 ++
 fs/proc/page.c                    |    2 +
 fs/proc/task_mmu.c                |  135 +++++++++++++++++++++----------------
 include/asm-generic/pgtable.h     |    4 +
 include/linux/huge_mm.h           |   17 +++++
 include/linux/kernel-page-flags.h |    1 +
 mm/huge_memory.c                  |  120 +++++++++++++++-----------------
 9 files changed, 169 insertions(+), 121 deletions(-)

Thanks,
Naoya
