Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1GNUUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:20:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62245 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1GNUUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E1F4D2C.3000507@zytor.com>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<1310462166-31469-14-git-send-email-tj@kernel.org>
	<4E1F4D2C.3000507@zytor.com>
Date: Thu, 14 Jul 2011 22:20:42 +0200
X-Google-Sender-Auth: je2dKE5myBb3f-qZqxSZStcuXyQ
Message-ID: <CAOS58YPhFWEYgB7moPoTj+BKBn6WMHCi5FqZ5eYp+m4bbEN_7A@mail.gmail.com>
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 14, 2011 at 10:10 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/12/2011 02:16 AM, Tejun Heo wrote:
>> +     memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
>> +                  base, base + size, (void *)_RET_IP_);
>>       BUG_ON(0 == size);
>>
>>       return memblock_add_region(_rgn, base, size);
>
> This assumes phys_addr_t == unsigned long long, which is just plain
> wrong.  I will fix it up, but please take more care with that in the
> future.  This triggers a warning when building for i386 non-PAE, which
> is a good thing because it is a real error.

Oh, right, I got confused w/ u64.

> Also, don't we usually display resources as an *inclusive* range,
> meaning that the last one should be base + size - 1?

Hmm... looking at the boot log, not really. [ ) ranges are more
common. memblock code is one of notable exceptions and I actually was
thinking about converting it. [ ) ranges are easier to recognize and
most of code we have can't deal with the full range (and it shouldn't
need to - chopping off one top and bottom is much saner approach
anyway).

Thanks.

-- 
tejun
