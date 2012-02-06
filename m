Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2BFViW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:38:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51377 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BFViV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:38:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120206162954.GE5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com> <20120206162954.GE5117@oksana.dev.rtsoft.ru>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 6 Feb 2012 16:38:01 -0500
Message-ID: <CAHGf_=rcvYj_NUyo7u1FX-h3=TsN=0W8MGB2zuK2cstfObxnYQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] staging: android/lowmemorykiller: No need for
 task->signal check
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

>  drivers/staging/android/lowmemorykiller.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index 0755e2f..6e800d3 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -136,19 +136,13 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>        rcu_read_lock();
>        for_each_process(tsk) {
>                struct task_struct *p;
> -               struct signal_struct *sig;
>                int oom_adj;
>
>                p = find_lock_task_mm(tsk);
>                if (!p)
>                        continue;
>
> -               sig = p->signal;
> -               if (!sig) {
> -                       task_unlock(p);
> -                       continue;
> -               }
> -               oom_adj = sig->oom_adj;
> +               oom_adj = p->signal->oom_adj;
>                if (oom_adj < min_adj) {
>                        task_unlock(p);
>                        continue;

ack.
