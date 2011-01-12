Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1ALFkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:40:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48586 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1ALFkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:40:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSfC/jUCk1KgMbxpz7O1Ag/vuNxotAnHXPtlRurXJzAygDLRcMZpF4OJ4D/LkNr9WQ
         SnJsdJaeO2irjgfH/l4qS3m2SJYobtaVgNYyyI10+zyvQMRbp/TFhOPBapIPOYM+xJrX
         tD4yGWP0LU6G3ig6URtHjzB3fi1nASH72yPDo=
MIME-Version: 1.0
In-Reply-To: <20110112033709.GA2723@in.ibm.com>
References: <20110110091622.GF2772@in.ibm.com>
	<1294655388.8197.22.camel@marge.simson.net>
	<1294657154.2016.459.camel@laptop>
	<1294677746.8345.4.camel@marge.simson.net>
	<20110111171046.GL4772@in.ibm.com>
	<1294771686.8006.15.camel@marge.simson.net>
	<20110112033709.GA2723@in.ibm.com>
Date: Wed, 12 Jan 2011 13:40:32 +0800
Message-ID: <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Yong Zhang <yong.zhang0@gmail.com>
To: bharata@linux.vnet.ibm.com
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 11:37 AM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
>> Unless I fscked up, set_task_rq() is the group change.  As soon as the
>> task's class changes, it'll be moved to the root_task_group.
>
> Ok, this is what I understand, may be Peter Z can confirm...
>
> set_task_rq() just changes the task's cfs_rq and rt_rq as per its
> task_group(). The normal way to change a task's group is to first
> change its cgroup pointer (task->cgroups, see cgroup_attach_task())
> After this you change the runqueues by calling set_task_rq() which
> now refers to new group's runqueues.
>
> In your code, I don't see where you really change task's group. AFAICS,
> it continues to remain in the same autogroup.

IMHO, task->cgroups will not change when autogroup take effect.
IOW, autogroup will only take effect when task belongs to root_task_group.

Thanks,
Yong

>
> Regards,
> Bharata.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
