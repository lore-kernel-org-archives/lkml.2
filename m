Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2BFVis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:38:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51377 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2BFVir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120206163001.GF5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com> <20120206163001.GF5117@oksana.dev.rtsoft.ru>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 6 Feb 2012 16:38:26 -0500
Message-ID: <CAHGf_=qk9_E5hd86NGkQ2fvxrhOLfY7DHPMTZ65KQXTCMWobTA@mail.gmail.com>
Subject: Re: [PATCH 6/6] staging: android/lowmemorykiller: Do not kill kernel threads
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/6 Anton Vorontsov <anton.vorontsov@linaro.org>:
> LMK should not try killing kernel threads.
>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  drivers/staging/android/lowmemorykiller.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index 6e800d3..ae38c39 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -138,6 +138,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>                struct task_struct *p;
>                int oom_adj;
>
> +               if (tsk->flags & PF_KTHREAD)
> +                       continue;
> +

ack.
