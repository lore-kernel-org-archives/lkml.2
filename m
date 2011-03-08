Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1CHBZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:25:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35139 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1CHBZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:25:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH rh6] mm: skip zombie in OOM-killer
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1299274256-2122-1-git-send-email-avagin@openvz.org>
References: <1299274256-2122-1-git-send-email-avagin@openvz.org>
Message-Id: <20110308102508.7E99.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 10:25:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A parent may wait a memory and zombie will prevent killing another task.
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  mm/oom_kill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7dcca55..2fc554e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -311,7 +311,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  		 * blocked waiting for another task which itself is waiting
>  		 * for memory. Is there a better alternative?
>  		 */
> -		if (test_tsk_thread_flag(p, TIF_MEMDIE))
> +		if (test_tsk_thread_flag(p, TIF_MEMDIE) && p->mm)
>  			return ERR_PTR(-1UL);

OK. Good catch.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




