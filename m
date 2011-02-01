Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1BALT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:19:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58572 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1BALT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:19:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OvRZbymGAE5z1uJcWlNi9tRE28uJLIEG7Dj43K4zIQZJnaOzEWrhqdnhAzh7mgPuKS
         bLLZn/iHrykpUqWido9/Gb4a3hqxN0sIrkSSE7e1DTA/DB/VnxoQjF4MvCBNOMk1zKmz
         2oegk0bSqiXHspg2QYXH5yFFhUQbBtVWnaAkw=
MIME-Version: 1.0
In-Reply-To: <20110201104602.GA3397@zhy>
References: <AANLkTikYw73nixqMtNSDzus2M5RCN2Zy4PzfbPAxtTBC@mail.gmail.com>
	<20110201104602.GA3397@zhy>
Date: Tue, 1 Feb 2011 20:19:57 +0900
X-Google-Sender-Auth: K3c-Ulv5FG6qva7fbqvD8KZwlUE
Message-ID: <AANLkTim8Rk1RyH=m2B6CDaGUVYCzc+ceB1xKxTmtasgD@mail.gmail.com>
Subject: Re: Why one of the 2 patches to fix "autogroup" sched problem on UP
 machines is missing in -rc3?
From: Kazuhisa Ichikawa <ki@epsilou.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually the merged one hide the initialising problem.
> Because when we enqueue a process to an empty group, update_cfs_shares()
> will be called, thus tg->se->load is updated.
> enqueue_task_fair()
>  update_cfs_shares()
>    reweight_entity()
>      update_load_set()

Ah, I see. Thanks for the clarification!

- Kazuhisa


2011/2/1 Yong Zhang <yong.zhang0@gmail.com>:
> On Tue, Feb 01, 2011 at 06:05:23PM +0900, Kazuhisa Ichikawa wrote:
>> Hi Yong,
>>
>> Now 2.6.38-rc3 is out, and I think one of the 2 patches you wrote to
>> fix "autogroup" sched problem on UP machines is missing there.
>
> Actually the merged one hide the initialising problem.
> Because when we enqueue a process to an empty group, update_cfs_shares()
> will be called, thus tg->se->load is updated.
> enqueue_task_fair()
>  update_cfs_shares()
>    reweight_entity()
>      update_load_set()
>
>>
>> More precisely, your first patch for kernel/sched.c (titled:?sched:
>> tg->se->load should be initialised to tg->shares) is missing, while
>> the second one for kernel/sched_fair.c (titled:?sched: Fix poor
>> interactivity on UP systems due to group scheduler nice tune bug) is
>> in -rc3.
>
> See my above answer.
>
>>
>> So what happened to the first patch? Was it superseded and made
>> obsolete by the second patch?
>
> Yes.
>
>>
>> # Sorry for not replying to your original post. I'm not subscribing to
>> linux kernel mailing list.
>
> Thanks for taking care of this issue :)
>
> Thanks,
> Yong
>
