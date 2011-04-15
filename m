Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1DOQdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:33:06 -0400
Received: from smtp.nokia.com ([147.243.128.26]:26273 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1DOQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:33:04 -0400
Date: Fri, 15 Apr 2011 19:28:24 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Michal Nazarewicz <mina86@mina86.com>
Cc: ext Andrea Arcangeli <aarcange@redhat.com>, akpm@linux-foundation.org,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] mm: make read-only accessors take const pointer
	parameters
Message-ID: <20110415162824.GF7112@esdhcp04044.research.nokia.com>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com> <20110415145133.GO15707@random.random> <20110415155916.GD7112@esdhcp04044.research.nokia.com> <op.vtzly7dk3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vtzly7dk3l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/11 18:12 +0200, ext Michal Nazarewicz wrote:
> On Fri, 15 Apr 2011 17:59:16 +0200, Phil Carmody wrote:
>> I'm just glad this wasn't an insta-nack, as I am quite a fan of
>> consts, and hopefully something can be worked out.
>
> I feel you man.  Unfortunately, I think that const, since it's an
> after-thought, is not very usable in C.
>
> For instance, as you've pointed in your patch, the "_ro" suffix
> is sort of dumb, but without it compound_head would have to take
> const and return non-const (like strchr() does) which is kinda
> stupid as well.
>
> What's more, because of lack of encapsulation, “const struct page”
> only means that the object is const but thighs it points to aren't.
> As such, const does not really play that well with structs anyway.

I'm very glad you've mentioned that point, I forgot to. I've taken
the view that in the absense of inside knowledge, const should be
inherited down all pointers. So not only will I not change you, but
I will not change anything you point to. No hidden side effects of
any kind. That reduces where it can be used, but is a much stronger
statement when it can be made.

> const is, in my opinion, one of those things C++ actually got
> right (or close to right).

I shouldn't be seen to agree with you on that, lest any fellow Nokians
notice that I've implied something positive about C++ after my rant on
our core chat channel a few days back. ;-)

Cheers,
Phil
