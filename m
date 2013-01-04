Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3ADFQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:16:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54670 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3ADFQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:16:56 -0500
X-AuditID: 9c930179-b7becae000000e51-e4-50e665c5a85e
From: Namhyung Kim <namhyung@kernel.org>
To: Eric Dumazet <erdnetdev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Subject: Re: [PATCH net-next] softirq: reduce latencies
References: <1357216132.21409.24107.camel@edumazet-glaptop>
	<20130103124608.136fd65b.akpm@linux-foundation.org>
	<1357252875.21409.26390.camel@edumazet-glaptop>
Date: Fri, 04 Jan 2013 14:16:53 +0900
In-Reply-To: <1357252875.21409.26390.camel@edumazet-glaptop> (Eric Dumazet's
	message of "Thu, 03 Jan 2013 14:41:15 -0800")
Message-ID: <87r4m1r0hm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 03 Jan 2013 14:41:15 -0800, Eric Dumazet wrote:
> On Thu, 2013-01-03 at 12:46 -0800, Andrew Morton wrote:
>> Can this change cause worsened latencies in some situations?  Say there
>> are a large number of short-running actions queued.  Presently we'll
>> dispatch ten of them and return.  With this change we'll dispatch many
>> more of them - however many consume 2ms.  So worst-case latency
>> increases from "10 * not-much" to "2 ms".
>
> I tried to reproduce such workload but couldnt. 2 ms (or more exactly 1
> to 2 ms given the jiffies/HZ granularity) is about the time needed to
> process 1000 frames on current hardware.

Probably a silly question:

Why not using ktime rather than jiffies for this?

Thanks,
Namhyung
