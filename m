Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2HEQKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:10:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51477 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2HEQKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:10:54 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120802180051.GI4537@opensource.wolfsonmicro.com>
References: <1343605633.11323.1.camel@phoenix> <20120730153309.GK4468@opensource.wolfsonmicro.com>
 <1343701316.7557.1.camel@phoenix> <20120731154153.GI4468@opensource.wolfsonmicro.com>
 <1343750888.5463.5.camel@phoenix> <20120802180051.GI4537@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 6 Aug 2012 00:10:33 +0800
Message-ID: <CAF+7xWmvnJ5LCz6GW+MVb8eExhmfVM=CSG_v==iAJ+2Kv=jmaw@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Add intermediate cast to uintptr_t
 before casting to pointer
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Aug 01, 2012 at 12:08:08AM +0800, Axel Lin wrote:
>> 於 二，2012-07-31 於 16:41 +0100，Mark Brown 提到：
>
>> > So the above cast probably isn't right...  you shouldn't need a double
>> > cast here.
>
>> The issue of original warning is: ( I compile the kernel on x86_64 )
>>         warning: cast to pointer from integer of different size
>
>> What this patch does is:
>> cast best_val to uintptr_t, which is an unsigned integer large enough to
>> hold a void* pointer.
>
>> And then cast it to (void *).
>
>> Thus I did (void *)(uintptr_t)best_val.
>
> Perhaps we need a temporary variable here.  The double cast just looks
> too horrible.

Either is ok to me.
But the double case looks better to me because the intention is clear.
It seems uintptr_t is less commonly used in drivers code.
Maybe just use (void *)(unsigned long)best_val is better in readability.
