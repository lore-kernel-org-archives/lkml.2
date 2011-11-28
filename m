Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1K1CS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:18:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58161 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1K1CSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:18:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Nov 2011 11:17:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.35.13: Schedule while atomic bug and kernel crash in
 kswapd.
Message-Id: <20111128111744.3020ad4d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAFPAmTQCcWf0yLm239b_fQTv9CY9t=B5gUrDO1wKM97pyrJurQ@mail.gmail.com>
References: <CAFPAmTQCcWf0yLm239b_fQTv9CY9t=B5gUrDO1wKM97pyrJurQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Nov 2011 18:20:31 +0530
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> Hi,
> 
> I am running linux-2.6.35.31 on my ARM system and I got around 197
> schedule while atomics and then finally a kernel crash.
> 
> Can anyone suggest some MMpatches to apply on this fix this problem ?
> 
> I got the following schedule while atomic log around 197 times:
> ------------------------------------------------------------------------------------------
> Backtrace(CPU 0):
> [<c00393a0>] (dump_backtrace+0x0/0x11c) from [<c0393728>] (dump_stack+0x20/0x24)
> [<c0393708>] (dump_stack+0x0/0x24) from [<c0058ad0>] (__schedule_bug+0x70/0x7c)
> [<c0058a60>] (__schedule_bug+0x0/0x7c) from [<c03939f8>] (schedule+0x74/0x5a4)
>   r5:d2002000 r4:d1f79440
>  [<c0393984>] (schedule+0x0/0x5a4) from [<c03948a0>]
> (schedule_timeout+0x2c8/0x304)
>  [<c03945d8>] (schedule_timeout+0x0/0x304) from [<c0393958>]
> (io_schedule_timeout+0x50/0x7c)
>   r7:d1f79440 r6:d2002000 r5:c04c0088 r4:c04bfc88
>  [<c0393908>] (io_schedule_timeout+0x0/0x7c) from [<c0109cbc>]
> (congestion_wait+0x7c/0xa0)
>   r6:00000019 r5:c04c6230 r4:d2003edc r3:00000000
>  [<c0109c40>] (congestion_wait+0x0/0xa0) from [<c0102268>] (kswapd+0x594/0x61c)
>   r7:00000000 r6:c04d7a28 r5:00000008 r4:c04d76f4
>  [<c0101cd4>] (kswapd+0x0/0x61c) from [<c007db6c>] (kthread+0x90/0x98)
>  [<c007dadc>] (kthread+0x0/0x98) from [<c00642f4>] (do_exit+0x0/0x708)
>   r7:00000013 r6:c00642f4 r5:c007dadc r4:d1f47f3c
>  BUG: scheduling while atomic: kswapd0/16/0x00000000
> 

Hmm, it seems strange and I never see this.
This seems __schedule_bug() is called but preempt_count() is 0x00000000.
Could you show your .config ?

Regards,
-Kame




