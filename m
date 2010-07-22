Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab0GVJtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:49:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47442 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVJtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:49:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 22 Jul 2010 11:50:58 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100722183432U.fujita.tomonori@lab.ntt.co.jp>
To: m.szyprowski@samsung.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: corbet@lwn.net, linux-mm@kvack.org, p.osciak@samsung.com,
        xiaolin.zhang@intel.com, hvaibhav@ti.com, robert.fekete@stericsson.com,
        marcus.xm.lorentzon@stericsson.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Message-id: <op.vf8oa80k7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <20100720181239.5a1fd090@bike.lwn.net>
 <20100722143652V.fujita.tomonori@lab.ntt.co.jp>
 <000001cb296f$6eba8fa0$4c2faee0$%szyprowski@samsung.com>
 <20100722183432U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 11:35:07 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> You have the feature in the wrong place.
>
> Your example: a camera driver and a video driver can share 20MB, then
> they want 20MB exclusively.
>
> You can reserve 20MB and make them share it. Then you can reserve 20MB
> for both exclusively.
>
> You know how the whole system works. Adjust drivers (probably, with
> module parameters).

So you are talking about moving complexity from the CMA core to the drivers.
Ie. instead of configuring regions and mapping via CMA command line
parameters, the whole configuration is pushed to modules.  We consider that
suboptimal because it (i) does not reduce complexity -- it just moves it
somewhere else, (ii) spreads the complexity to many modules instead of
single core of CMA, and (iii) spreads the configuration to many modules
instead of keeping it in one place.


> When a video driver needs 20MB to work properly, what's the point of
> releasing the 20MB for others then trying to get it again later?

If you have a video driver that needs 20MiB and a camera that needs 20MiB
will you reserve 40MiB total? That's 20MiB wasted if on your system those
two can never work at the same time.  So do you reserve 20MiB and share?
That won't work if on your system the two can work at the same time.

With CMA you can configure the kernel for both cases.

> Even with the above example (two devices never use the memory at the
> same time), the driver needs memory regularly. What's the point of
> split the 20MB to small chunks and allocate them to others?

Lost you there...  If something does not make sense on your system you
don't configure CMA to do that.  That's one of the points of CMA.  What
does not make sense on your platform may make perfect sense on some
other system, with some other drivers maybe.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
