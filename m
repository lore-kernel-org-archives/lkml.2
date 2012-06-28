Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2F1OJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:09:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2F1OJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:09:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120627230230.GT15811@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
	<20120627182903.GP15811@google.com>
	<20120627230230.GT15811@google.com>
Date: Thu, 28 Jun 2012 23:09:43 +0900
Message-ID: <CALLJCT2_BWSm6NOJoBp8j+5zoEoa-B=predDpei8-6aGO36xng@mail.gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
From: Masanari Iida <standby24x7@gmail.com>
To: "tj@kernel.org" <tj@kernel.org>
Cc: shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I have applied this patch on 3.5-rc4, and tested.
It didn't fix the symptom. :(

Masanari


On Thu, Jun 28, 2012 at 8:02 AM, tj@kernel.org <tj@kernel.org> wrote:
> Hello,
>
> Does the following patch make the problem go away?
>
> Thank you.
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2097684..f9556cf 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -3644,6 +3644,7 @@ static void cgroup_event_remove(struct work_struct *work)
>        eventfd_ctx_put(event->eventfd);
>        kfree(event);
>        dput(cgrp->dentry);
> +       deactivate_super(cgrp->root->sb);
>  }
>
>  /*
> @@ -3770,6 +3771,7 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
>         * destroying subsystem state objects. Let's take reference to cgroup
>         * directory dentry to do that.
>         */
> +       atomic_inc(&cgrp->root->sb->s_active);
>        dget(cgrp->dentry);
>
>        spin_lock(&cgrp->event_list_lock);
