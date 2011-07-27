Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1G0FrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 01:47:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40098 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1G0FrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 01:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E2FA002.2020302@jp.fujitsu.com>
References: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
	<1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
	<4E2FA002.2020302@jp.fujitsu.com>
Date: Wed, 27 Jul 2011 13:47:15 +0800
Message-ID: <CAM2zO=AiGqbyna8NeC8PZxGBJzHokLKyixE6wv6nac3-OjzcWQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc/insterrupts: make it cpu hotplug safe
From: Yong Zhang <yong.zhang0@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kobayashi.kk@ncos.nec.co.jp,
        heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> (2011/07/27 13:56), Yong Zhang wrote:
>> KOSAKI Motonhiro noticed that the reader of /proc/interrupts
>> could be preempted by cpu hotplug, thus the reader can get
>> broken result due to show_interrupts() iterate every online
>> cpu without any protection.
>>
>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> Looks good. but I have a question. On last thread, kobayashi-san
> suggested to use for_each_possible_cpu() and you wrote "+1".

Yeah, for_each_possible_cpu() will make code more cleaner.
so I give it my support.

>
>>> At that time, I suggested to change
>>> from for_each_online_cpu() to for_each_possible_cpu(),
>>> in /proc/interrupts.
>>+1
>>Thus we could also avoid the issue pointed by KOSAKI Motonhiro.
>
> Why do you decide to use another way?

But, as kobayashi-san has also said:
In conclusion, we decided to remain /proc/interrupts.
because it had been the way for a long time.

So I don't want to raise an argument again :)

Thanks,
Yong


-- 
Only stand for myself
