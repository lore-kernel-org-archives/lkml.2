Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0HJAHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:07:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757321Ab0HJAHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:07:12 -0400
Date: Mon, 9 Aug 2010 17:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gpio-addr-flash warnings on x86/highmem (Re: i386 allmodconfig,
 current mainline)
Message-Id: <20100809170709.9c16c756.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikjeQ=b7c85R0-yVzSOiMKWbWksnBRiz0wmOaN2@mail.gmail.com>
References: <AANLkTikjeQ=b7c85R0-yVzSOiMKWbWksnBRiz0wmOaN2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010 19:52:35 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Mon, Aug 9, 2010 at 19:43, Andrew Morton wrote:
> > Guys. __What's goin' on out there?
> >
> > drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
> > drivers/mtd/maps/gpio-addr-flash.c:212: warning: cast to pointer from integer of different size
> > drivers/mtd/maps/gpio-addr-flash.c:224: warning: cast to pointer from integer of different size
> 
> i did get a bug report about this in the past, but honestly i havent
> gotten around to fixing the issues.  it's been low priority as my
> understanding is that the warning shows up in configurations where the
> driver isnt realistically usable.  not making excuses, just laying out
> the reality of things.

Casting a resource_size_t to a kernel pointer is plain naughty.

I guess an acceptable "fix" would be to disable to offending combinations
in Kconfig and add a

	BUILD_BUG_ON(sizeof(gpios->start) != sizeof(void *))

to catch stragglers.

But please do fix warnings, if only because the warning storm from
allmodconfig causes people to miss important warnings in all the noise.
