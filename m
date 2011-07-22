Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1GVTWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:22:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946Ab1GVTWW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:22:22 -0400
MIME-Version: 1.0
In-Reply-To: <4E29CB5B.4040408@unsolicited.net>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
 <4E29CB5B.4040408@unsolicited.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jul 2011 12:21:31 -0700
Message-ID: <CA+55aFy1FnVGH4C_0T8fXwZPUdz5-SCczMwy1K8kydLwTx89RQ@mail.gmail.com>
Subject: Re: Linux 3.0 release
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 12:11 PM, David <david@unsolicited.net> wrote:
>
> I'm getting the following warning at boot from 3.0, everything seems to be fine otherwise though.
>
> Jul 22 19:40:02 server kernel: [   15.526629] ------------[ cut here ]------------
> Jul 22 19:40:02 server kernel: [   15.526635] WARNING: at kernel/timer.c:1011 del_timer_sync+0x4e/0x50()

Hmm. That looks like a real bug: you shouldn't do a "del_timer_sync()"
from an interrupt. It probably works, but it sounds like a really bad
idea.

> Jul 22 19:40:02 server kernel: [   15.526677]  [<ffffffff81054b4e>] del_timer_sync+0x4e/0x50
> Jul 22 19:40:02 server kernel: [   15.526679]  [<ffffffff8145e224>] linkwatch_schedule_work+0x84/0xa0
> Jul 22 19:40:02 server kernel: [   15.526681]  [<ffffffff8145e2bc>] linkwatch_fire_event+0x7c/0x100
> Jul 22 19:40:02 server kernel: [   15.526684]  [<ffffffff8146b1ed>] netif_carrier_on+0x2d/0x40
> Jul 22 19:40:02 server kernel: [   15.526689]  [<ffffffffa006b6fb>] __rtl8169_check_link_status+0x4b/0xc0 [r8169]
> Jul 22 19:40:02 server kernel: [   15.526693]  [<ffffffffa006c016>] rtl8169_interrupt+0x166/0x3a0 [r8169]
> Jul 22 19:40:02 server kernel: [   15.526696]  [<ffffffff810a4385>] handle_irq_event_percpu+0x55/0x1f0
> Jul 22 19:40:02 server kernel: [   15.526698]  [<ffffffff810a4551>] handle_irq_event+0x31/0x50

I'm not seeing a lot of changes in any of these areas, though. I
wonder what made it start happen.

                     Linus
