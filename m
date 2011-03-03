Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1CCDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:09:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47718 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab1CCDJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:09:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 4/4] exec: document acct_arg_size()
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
In-Reply-To: <20110302162812.GE26810@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162812.GE26810@redhat.com>
Message-Id: <20110303120917.B954.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 12:09:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the comment to explain acct_arg_size().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  fs/exec.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- 38/fs/exec.c~4_doc_acct_arg_size	2011-03-02 16:21:57.000000000 +0100
> +++ 38/fs/exec.c	2011-03-02 16:27:24.000000000 +0100
> @@ -164,7 +164,12 @@ out:
>  }
>  
>  #ifdef CONFIG_MMU
> -
> +/*
> + * The nascent bprm->mm is not visible until exec_mmap() but it can
> + * use a lot of memory, account these pages in current->mm temporary
> + * for oom_badness()->get_mm_rss(). Once exec succeeds or fails, we
> + * change the counter back via acct_arg_size(0).
> + */
>  static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
>  {
>  	struct mm_struct *mm = current->mm;
> 

Yeah! Thank you very much to make proper and clear comment.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



