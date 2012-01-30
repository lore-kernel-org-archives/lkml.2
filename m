Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2A3Gcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:32:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60271 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2A3Gcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 01:32:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 30 Jan 2012 15:31:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] pagemap: introduce data structure for pagemap entry
Message-Id: <20120130153111.4fefb09a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1327705373-29395-7-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1327705373-29395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1327705373-29395-7-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 18:02:53 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently a local variable of pagemap entry in pagemap_pte_range()
> is named pfn and typed with u64, but it's not correct (pfn should
> be unsigned long.)
> This patch introduces special type for pagemap entry and replace
> code with it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/proc/task_mmu.c |   66 +++++++++++++++++++++++++++------------------------
>  1 files changed, 35 insertions(+), 31 deletions(-)
> 
> diff --git 3.3-rc1.orig/fs/proc/task_mmu.c 3.3-rc1/fs/proc/task_mmu.c
> index e2063d9..c2807a3 100644
> --- 3.3-rc1.orig/fs/proc/task_mmu.c
> +++ 3.3-rc1/fs/proc/task_mmu.c
> @@ -586,9 +586,13 @@ const struct file_operations proc_clear_refs_operations = {
>  	.llseek		= noop_llseek,
>  };
>  
> +typedef struct {
> +	u64 pme;
> +} pme_t;
> +

A nitpick..

How about pagemap_entry_t rather than pme_t ?

At 1st look, I wondered whether this is a new kind of page table entry type or not ..

Thanks,
-Kame

