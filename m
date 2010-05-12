Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0ELAXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:23:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58194 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0ELAXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:23:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and rmap_walk() during migration by not migrating temporary stacks
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100511085752.GM26611@csn.ul.ie>
References: <20100511085752.GM26611@csn.ul.ie>
Message-Id: <20100512092239.2120.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 12 May 2010 09:23:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/exec.c b/fs/exec.c
> index 725d7ef..13f8e7f 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -242,9 +242,10 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>  	 * use STACK_TOP because that can depend on attributes which aren't
>  	 * configured yet.
>  	 */
> +	BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);

Can we use BUILD_BUG_ON()? 

but anyway
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



