Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0FYIKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:10:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0FYIKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QDfjqvaN+92hreKvX82nH/oAu1C6Ioa/FElsfDsr4LiCIDl9FEqbqYTLCT9lmzcmZZ
         qT4riDakoBHH6pQKIzOdO+6BxWFQGN3CtpzEbI936vRb1hJArmpGNFkwxS1xTtc4/S2Z
         JCeeHFC30H3cQu2bNjiqfqG3hQ/KQ3hwNi1rI=
MIME-Version: 1.0
In-Reply-To: <20100625100718.8034.A69D9226@jp.fujitsu.com>
References: <4C2312A8.9060903@jp.fujitsu.com>
	<4C23FF0E.4020908@jp.fujitsu.com>
	<20100625100718.8034.A69D9226@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 09:46:04 +0200
Message-ID: <AANLkTintuABuImW9fIW-Dy7hAd0FIgoJZc4unr4FQa6O@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/5] irq: add tracepoint to softirq_raise
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/25 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> (cc to Lai)
>
>> This patch adds a tracepoint to raising of softirq.
>> This is useful if you want to detect which hard interrupt raise softirq
>> and lets you know a time between raising softirq and performing softirq.
>> Combinating with other tracepoint, it lets us know a process of packets
>> (See patch 0/5).
>>
>>           <idle>-0     [001] 241229.957184: softirq_raise: vec=3 [action=NET_RX]
>>           <idle>-0     [000] 241229.993399: softirq_raise: vec=1 [action=TIMER]
>>           <idle>-0     [000] 241229.993400: softirq_raise: vec=9 [action=RCU]
>>
>> This is a same patch Lai Jiangshan submitted.
>> http://marc.info/?l=linux-kernel&m=126026122728732&w=2
>
> If so, you shouldn't remove author's info. please fix the description
> as following.
>
> -------------------------------------------------------------------------
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>
> This patch adds a tracepoint to raising of softirq.
> This is useful if you want to detect which hard interrupt raise softirq
> and lets you know a time between raising softirq and performing softirq.
> Combinating with other tracepoint, it lets us know a process of packets
> (See patch 0/5).
>
>          <idle>-0     [001] 241229.957184: softirq_raise: vec=3 [action=NET_RX]
>          <idle>-0     [000] 241229.993399: softirq_raise: vec=1 [action=TIMER]
>          <idle>-0     [000] 241229.993400: softirq_raise: vec=9 [action=RCU]
>
> This is a same below.
> http://marc.info/?l=linux-kernel&m=126026122728732&w=2
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


Right. And if you do some changes in the original patch, you can just
change the description, or add a simple line before your Signed-off-by, that
says:

[ factorize softirq events with DECLARE_EVENT_CLASS ]

Because indeed, as Steve said, the softirq_raise tracepoint should
belong to the softirq event class as it perfectly matches it. This
helps the kernel
saving some space.

Thanks.


> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> --------------------------------------------------------------------------------
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
