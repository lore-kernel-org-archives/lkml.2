Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1CCDBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:01:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49150 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab1CCDBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:01:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 1/4] exec: introduce get_arg_ptr() helper
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
In-Reply-To: <20110302162712.GB26810@redhat.com>
References: <20110302162650.GA26810@redhat.com> <20110302162712.GB26810@redhat.com>
Message-Id: <20110303114952.B94B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 12:01:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for the long delay. now I'm getting stuck sucky paper work. ;-)
In short, I don't find any issue in this patch. So, I'll test it at
this weekend if linus haven't merged it yet.

A few small and cosmetic comments are below. but anyway I don't want
keep this up in the air.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> Introduce get_arg_ptr() helper, convert count() and copy_strings()
> to use it.
> 
> No functional changes, preparation. This helper is trivial, it just
> reads the pointer from argv/envp user-space array.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  fs/exec.c |   36 +++++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
> 
> --- 38/fs/exec.c~1_get_arg_ptr	2011-03-02 15:15:27.000000000 +0100
> +++ 38/fs/exec.c	2011-03-02 15:16:44.000000000 +0100
> @@ -395,6 +395,17 @@ err:
>  	return err;
>  }
>  
> +static const char __user *
> +get_arg_ptr(const char __user * const __user *argv, int argc)
> +{

[argc, argv] is natural order to me than [argv, argc].
and "get_" prefix are usually used for reference count incrementing
function in linux. so, i _personally_ prefer to call "user_arg_ptr".



