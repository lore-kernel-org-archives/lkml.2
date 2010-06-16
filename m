Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0FPEmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:42:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52525 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0FPEmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lbh+PMVzWQV2kfBP+yhUG/E3t2Fm6rI8bbQA1vH0IwvlUUUvQTM5NYY0GYF1AYnpAv
         FZOpwWwscn2iqEyiEHgqnLxaFBfVs1FfL2k5T9zqU5p2Cib8kE1zcQvVf2IgkCv2bj/L
         9wjH/7GLzHREdeSEee9hgCuk/pZ6C54DeWsEo=
MIME-Version: 1.0
In-Reply-To: <20100616090334.d27e0c4e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100615152450.f82c1f8c.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinEEYWULLICKqBr4yX7GL01E4cq0jQSfuN8J6Jq@mail.gmail.com>
	<20100616090334.d27e0c4e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 16 Jun 2010 10:12:20 +0530
X-Google-Sender-Auth: tv3XEbKs8zxCWroMnt-9z_f-6eY
Message-ID: <AANLkTikGcl8l8TvSWx2Ij7I5E-TVjGplRU5YfX0mTAG0@mail.gmail.com>
Subject: Re: [PATCH] use find_lock_task_mm in memory cgroups oom v2
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Oleg Nesterov <oleg@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 5:33 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 15 Jun 2010 18:59:25 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> > -/*
>> > +/**
>> > + * find_lock_task_mm - Checking a process which a task belongs to has valid mm
>> > + * and return a locked task which has a valid pointer to mm.
>> > + *
>>
>> This comment should have been another patch.
>> BTW, below comment uses "subthread" word.
>> Personally it's easy to understand function's goal to me. :)
>>
>> How about following as?
>> Checking a process which has any subthread with vaild mm
>> ....
>>
> Sure. thank you. v2 is here. I removed unnecessary parts.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> When the OOM killer scans task, it check a task is under memcg or
> not when it's called via memcg's context.
>
> But, as Oleg pointed out, a thread group leader may have NULL ->mm
> and task_in_mem_cgroup() may do wrong decision. We have to use
> find_lock_task_mm() in memcg as generic OOM-Killer does.
>
> Changelog:
>  - removed unnecessary changes in comments.
>

mm->owner solves the same problem, but unfortunately we have task
based selection in OOM killer, so we need this patch. It is quite
ironic that we find the mm from the task and then eventually the task
back from mm->owner and then the mem cgroup. If we already know the mm
from oom_kill.c, I think we can change the function to work off of
that. mm->owner->cgroup..no?

Balbir
