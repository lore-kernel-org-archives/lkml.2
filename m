Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1CCDIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:08:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57193 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab1CCDIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:08:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 2/4] exec: introduce struct conditional_ptr
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
In-Reply-To: <20110302162732.GC26810@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162732.GC26810@redhat.com>
Message-Id: <20110303120211.B94E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 12:08:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No functional changes, preparation.
> 
> Introduce struct conditional_ptr, change do_execve() paths to use it
> instead of "char __user * const __user *argv".
> 
> This makes the argv/envp arguments opaque, we are ready to handle the
> compat case which needs argv pointing to compat_uptr_t.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  fs/exec.c |   42 ++++++++++++++++++++++++++++++------------
>  1 file changed, 30 insertions(+), 12 deletions(-)
> 
> --- 38/fs/exec.c~2_typedef_for_argv	2011-03-02 15:40:22.000000000 +0100
> +++ 38/fs/exec.c	2011-03-02 15:40:44.000000000 +0100
> @@ -395,12 +395,15 @@ err:
>  	return err;
>  }
>  
> -static const char __user *
> -get_arg_ptr(const char __user * const __user *argv, int argc)
> +struct conditional_ptr {

I _personally_ don't like "conditional". Its name is based on code logic.
It's unclear what mean "conditional". From data strucuture view, It is 
"opaque userland pointer".

but again, it is my personal preference.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



