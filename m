Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2LLH35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 02:29:57 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52185 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2LLH34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 02:29:56 -0500
MIME-Version: 1.0
In-Reply-To: <20121211142518.GA5580@redhat.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
	<20121211142518.GA5580@redhat.com>
Date: Wed, 12 Dec 2012 15:29:55 +0800
X-Google-Sender-Auth: fdhVw7LW29KuN4rgwLeOtrfuSK8
Message-ID: <CAFVn34TqCk71PDgdTAhBo9qTmhD3OwO9RxuyNRXwtkJoYqtOZg@mail.gmail.com>
Subject: Re: performance drop after using blkcg
From: Zhao Shuai <zhaoshuai@freebsd.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: tj@kernel.org, axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/11 Vivek Goyal <vgoyal@redhat.com>:
> These results are with slice_idle=0?

Yes, slice_idle is disabled.

> What's the storage you are using. Looking at the speed of IO I would
> guess it is not one of those rotational disks.

I have done the same test on 3 different type of boxes,and all of them
show a performance drop(30%-40%) after using blkcg. Though they
have different type of disk, all the storage they use are traditional
rotational
devices(e.g."HP EG0146FAWHU", "IBM-ESXS").

> So if somebody wants to experiment, just tweak the code a bit to allow
> preemption when a queue which lost share gets backlogged and you
> practially have a prototype of iops based group scheduling.

Could you please explain more on this? How to adjust the code? I have test
the following code piece, the result is we lost group differentiation.

cfq_group_served() {
         if (iops_mode(cfqd))
                 charge = cfqq->slice_dispatch;
         cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
 }


-- 
Regards,
Zhao Shuai
