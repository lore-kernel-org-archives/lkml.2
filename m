Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1AXGLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 01:11:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50834 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AXGLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T+Ro5Jcie/V4ekbuYPw/rRmMg+FsX5ed0MLF6jHTOMNsukAM6Bc6a/kaOIULWEFOvv
         yi/9QfxGpWB0GgD+BUA1S3q92gCfuHuQHJZb1+UJAASjp7k6zzx2AyDwXnwNI5NlQXSL
         UV/xKK56dciafsXUB046k7QK2fQlC/35RCxBA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
References: <20110123150341.GA2643@zhy>
	<1295847626-2396-1-git-send-email-yong.zhang0@gmail.com>
	<AANLkTi=gRO0tCdEzmn3Ne6Wj6bXd1G8nhLw2E_-Yw3WA@mail.gmail.com>
Date: Mon, 24 Jan 2011 14:11:20 +0800
Message-ID: <AANLkTi=3f8nvEuFbHqjnTXtrK_sAC-A9+XAMjAHgjT3d@mail.gmail.com>
Subject: Re: [PATCH V2] sched: fix autogroup nice tune on UP
From: Yong Zhang <yong.zhang0@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, mfwitten@gmail.com,
        christian@nerdbynature.de, a.p.zijlstra@chello.nl,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 1:54 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Jan 24, 2011 at 7:40 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> +static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
>> +{
>> +       struct task_group *tg;
>> +       struct sched_entity *se;
>> +
>> +       if (!cfs_rq)
>> +               return;
>> +
>> +       tg = cfs_rq->tg;
>> +       se = tg->se[0];
>> +       if (!se)
>> +               return;
>> +       if (likely(se->load.weight == tg->shares))
>> +               return;
>> +       reweight_entity(cfs_rq_of(se), se, tg->shares);
>> +}
>
> Wouldn't it be cleaner if we'd separate the shares calculation in a
> separate helper function that's just
>
>  return tg->shares;

I'm not sure I get your point correctly.
You mean the two tg->shares above, right?

If so, yeah, we can declare a variable for that.

>
> for UP and extract the current logic for the SMP version?
>

This is the UP specific version, I don't touch SMP version.
On SMP, update_cfs_shares() is more complex.

Thanks,
Yong


-- 
Only stand for myself
