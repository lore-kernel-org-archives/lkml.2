Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2F1HxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 03:53:21 -0400
Received: from smtp.witbe.net ([81.88.96.48]:37615 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab2F1HxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 03:53:19 -0400
Date: Thu, 28 Jun 2012 09:51:03 +0200
From: Paul Rolland <rol@as2917.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120628095103.3c6c0a1e@tux.DEF.witbe.net>
In-Reply-To: <20120627182202.GO15811@google.com>
References: <20120627195808.31714295@tux.DEF.witbe.net>
 <20120627182202.GO15811@google.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 27 Jun 2012 11:22:02 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> > io scheduler noop registered
> Can you please test the following branch?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> for-linus

Well code is the same.... so is the result :

[root@tux ~]# uname -a
Linux tux.DEF.witbe.net 3.5.0-rc4-g6b16351 #1 SMP PREEMPT Thu Jun 28
09:11:07 CEST 2012 x86_64 x86_64 x86_64 GNU/Linux

and

------------[ cut here ]------------
WARNING: at block/blk-cgroup.c:867 blkcg_policy_register+0xb5/0xc0()
Hardware name: Vostro 1520
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc4-g6b16351 #1
Call Trace:
 [<ffffffff8103a59a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81cafbee>] ? deadline_init+0x12/0x12
 [<ffffffff8103a5e5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8131aab5>] blkcg_policy_register+0xb5/0xc0
 [<ffffffff81cafc30>] cfq_init+0x42/0x9f
 [<ffffffff810001ba>] do_one_initcall+0x3a/0x160
 [<ffffffff81c8ed08>] kernel_init+0x137/0x1bb
 [<ffffffff81c8e5c5>] ? do_early_param+0x87/0x87
 [<ffffffff8169e954>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c8ebd1>] ? start_kernel+0x3b2/0x3b2
 [<ffffffff8169e950>] ? gs_change+0xb/0xb
---[ end trace 82bc55f036371117 ]---

and of course cfq is missing in :
[root@tux ~]# cat /sys/block/sda/queue/scheduler 
[noop] deadline 

Looking at the code, it seems strange that cfq_init requires
blkcg_policy_register to be successfull, wether you have defined
CFQ_CGROUP_IOSCHED or not.

So, I applied the following patch, and I now have:
[root@tux ~]# cat /sys/block/sda/queue/scheduler 
noop deadline [cfq] 

Not sure this is the correct patch, but at least it works for me (tm) ;)

Signed-Off-by: Paul Rolland <rol@as2917.net> 

diff -urN block/cfq-iosched.orig block/cfq-iosched.c
--- block/cfq-iosched.orig      2012-06-28 09:39:06.000000000 +0200
+++ block/cfq-iosched.c 2012-06-28 09:39:31.000000000 +0200
@@ -4198,9 +4198,11 @@
                cfq_group_idle = 0;
 #endif
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
        ret = blkcg_policy_register(&blkcg_policy_cfq);
        if (ret)
                return ret;
+#endif
 
        cfq_pool = KMEM_CACHE(cfq_queue, 0);
        if (!cfq_pool)
@@ -4215,7 +4217,9 @@
 err_free_pool:
        kmem_cache_destroy(cfq_pool);
 err_pol_unreg:
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
        blkcg_policy_unregister(&blkcg_policy_cfq);
+#endif
        return ret;
 }


Paul
