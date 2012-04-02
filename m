Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab2DBLIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:08:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57888 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2DBLIf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:08:35 -0400
MIME-Version: 1.0
In-Reply-To: <1333269879.2325.4771.camel@edumazet-glaptop>
References: <CAFgQCTtg1U7V_WbJ2uZG9unM5qV6sPfoCMbrMVdXrebwue6wzg@mail.gmail.com>
	<1333269879.2325.4771.camel@edumazet-glaptop>
Date: Mon, 2 Apr 2012 19:08:35 +0800
Message-ID: <CAFgQCTvYmf=mVi9TceYQ8gDu_X5SM5-kexR8GwY-mHP2UBLY_g@mail.gmail.com>
Subject: Re: net-sched: When TX over-limit happens on netdev, what does kernel do?
From: Liu ping fan <kernelfans@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-net@vger.kernel.org, Jamal Hadi Salim <hadi@cyberus.ca>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 4:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Sun, 2012-04-01 at 16:27 +0800, Liu ping fan wrote:
>> Hi,
>>
>> Could anybody tell me when TX over-limit happens on netdev, what does kernel do?
>> Is skb buffered in Qdisc->q and the sending process keeps running?
>
> Are you referring to the NETDEV_TX_BUSY return code processing ?
>
Yes.
>> Or we block the sending process and make it scheduled?
>>
>
> We never block the sender process in qdisc layer.
>
For qdisc layer in softirq?

> Only upper protocol layers can eventually block if too many packets are
> in flight on the socket.
>
>> Found some code in net/sched/sch_cbq.c
>> cbq_dequeue(struct Qdisc *sch) --> qdisc_watchdog_schedule(),  so I
>> guess the skb is buffered in Qdisc, but what about sending process?
>
> sender queued its packet and doesnt care if the packet is sent or not.
>
> Only problem is when qdisc limit (number of packets in queue) is hit,
> then we can return an error to sender (packet dropped or congestion
> notification)
>
Got it, thanks.

Regards,
pingfan
>
>
