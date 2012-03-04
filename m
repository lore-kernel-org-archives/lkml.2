Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2CDM3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 07:29:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2CDM3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 07:29:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of richard.weinberger@gmail.com designates 10.68.220.196 as permitted sender) smtp.mail=richard.weinberger@gmail.com; dkim=pass header.i=richard.weinberger@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330863026-2696-1-git-send-email-linkinjeon@gmail.com>
References: <1330863026-2696-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 4 Mar 2012 13:29:19 +0100
Message-ID: <CAFLxGvyt_-WFLe_WJGGz4oztSAiYoKk1+BD9_OsK4toSjP4V5Q@mail.gmail.com>
Subject: Re: [PATCH] cfq: fix NULL pointer dereference in cfq_choose_cfqg.
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 1:10 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> I found null pointer dereferencing possibility while reviewing.
> If cfq_get_next_cfqg return null by RB_EMPTY_ROOT, null pointer dereferencing error can occur.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  block/cfq-iosched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d0ba505..d924272 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2306,7 +2306,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
>        cfqd->serving_group = cfqg;
>
>        /* Restore the workload type data */
> -       if (cfqg->saved_workload_slice) {
> +       if (!cfqg && cfqg->saved_workload_slice) {
>                cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
>                cfqd->serving_type = cfqg->saved_workload;
>                cfqd->serving_prio = cfqg->saved_serving_prio;

I don't think that this is a correct fix.

1. Can it really happen that cfq_get_next_cfqg() returns NULL at this point?

2. Adding a if(!cfgg ...) does not solve the problem, it ignores it.
After the if block we call choose_service_tree().
I'm sure choose_service_tree() it not happy when we pass a NULL pointer to it...

-- 
Thanks,
//richard
