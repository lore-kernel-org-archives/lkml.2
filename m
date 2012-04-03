Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2DCDAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 23:00:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33010 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2DCDAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 23:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <1333420612.26079.6.camel@joe2Laptop>
References: <1333415903.860.0.camel@mop> <1333420612.26079.6.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Apr 2012 05:00:10 +0200
Message-ID: <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 04:36, Joe Perches <joe@perches.com> wrote:
> On Tue, 2012-04-03 at 03:18 +0200, Kay Sievers wrote:

>>   hpet0: at MMIO 0xfed00000, IRQs
>>    2
>>   , 8
>>   , 0

> You are going to find many, many _hundreds_ of these.

Yeah, and they should all be fixed over time. It's 2012 and time to
make kernel log messages readable for machines, not for humans to
puzzle them together. :)

> Maybe it'd be better to aggregate content rather like
> printk does.  Aggregate until you get a newline or a
> new KERN_<LEVEL>

The continuation printk() can can always go wrong when multiple
threads do that in parallel. We can try to make it better with a
per-cpu buffer, but I guess there will always be a situation where
this can happen.

I'm confident, that only callers who are willing to take that 'risk'
of interleaved messages should be exposed to the problem, and never
ones who print proper single lines.

In other words, we should guarantee that there is no garbage left from
any earlier printk() for someone who does not want to play this
continuation print() game.

> A couple of other trivial comments:
>
> It's better to try to coalesce multiple printks(KERN_CONT
> (perhaps it's better to use pr_cont instead too)
>
> Branches with the same printks should be hoisted where
> possible.

Sure, please send patches for anything that is more appropriate to use here.

I did not want to change any logic which needs to be tested. I just
trivially added the obviously missing prefix, which solved the
problem, and which could be applied right away.

Kay
