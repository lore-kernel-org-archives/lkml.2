Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1KNXKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:10:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab1KNXKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:10:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (pm tree related)
Date: Tue, 15 Nov 2011 00:12:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <20111114142423.fe126b8c8cfd275d7dd138cc@canb.auug.org.au>
In-Reply-To: <20111114142423.fe126b8c8cfd275d7dd138cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150012.56306.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 14, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the final tree, today's linux-next build (powerpc
> allnoconfig) failed like this:
> 
> mm/oom_kill.c: In function 'select_bad_process':
> mm/oom_kill.c:326:5: error: implicit declaration of function '__thaw_task' [-Werror=implicit-function-declaration]
> 
> Caused by commit 23527e313ca5 ("PM / Freezer: Fix fallout of thaw_process()
> -> __thaw_task() rename").  __thaw_task() is only declared id
> CONFIG_FREEZER is set.  Commit 944e192db53c ("freezer: rename thaw_process()
> to __thaw_task() and simplify the implementation") removed the second
> declaration of thaw_process() without replacing it ...
> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 14 Nov 2011 14:19:32 +1100
> Subject: [PATCH] freezer: fix more fallout from the thaw_process rename
> 
> Commit 944e192db53c "freezer: rename thaw_process() to __thaw_task()
> and simplify the implementation" did not create a !CONFIG_FREEZER version
> of __thaw_task().
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I've applied your patch to linux-pm/pm-freezer and merged it into
linux-pm/linux-next.

Thanks,
Rafael


> ---
>  include/linux/freezer.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index cc779bb..a9dccc6 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -166,6 +166,7 @@ static inline bool set_freezable_with_signal(void)
>  #else /* !CONFIG_FREEZER */
>  static inline bool frozen(struct task_struct *p) { return false; }
>  static inline bool freezing(struct task_struct *p) { return false; }
> +static inline void __thaw_task(struct task_struct *t) {}
>  
>  static inline bool __refrigerator(bool check_kthr_stop) { return false; }
>  static inline int freeze_processes(void) { return -ENOSYS; }
> 

