Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab2F0TWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:22:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2F0TWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120627181330.GN15811@google.com>
References: <20120619041154.GA28651@shangw>
	<20120619212059.GJ32733@google.com>
	<20120619212618.GK32733@google.com>
	<CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
	<20120621201728.GB4642@google.com>
	<CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
	<20120622185113.GK4642@google.com>
	<CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
	<20120622192919.GL4642@google.com>
	<CAE9FiQVeJYwpgHjAFp5Q7PazOjeDvN_etrnej987Rc94TjXfAg@mail.gmail.com>
	<20120627181330.GN15811@google.com>
Date: Wed, 27 Jun 2012 12:22:14 -0700
X-Google-Sender-Auth: 8gVgXaS_5jx4pAXXeySxpa386DY
Message-ID: <CAE9FiQXk4abAzuKN8xiA5p5OJaG4UMzQR_Jzx2SsKOuUnKON_A@mail.gmail.com>
Subject: Re: Early boot panic on machine with lots of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 11:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Yinghai.
>
> Sorry about the delay.  I'm in bug storm somehow. :(
>
> On Fri, Jun 22, 2012 at 07:14:43PM -0700, Yinghai Lu wrote:
>> On Fri, Jun 22, 2012 at 12:29 PM, Tejun Heo <tj@kernel.org> wrote:
>> > I wish we had a single call - say, memblock_die(), or whatever - so
>> > that there's a clear indication that memblock usage is done, but yeah
>> > maybe another day.  Will review the patch itself.  BTW, can't you post
>> > patches inline anymore?  Attaching is better than corrupt but is still
>> > a bit annoying for review.
>>
>> please check the three patches:
>
> Heh, reviewing is cumbersome this way but here are my comments.
>
> * "[PATCH] memblock: free allocated memblock_reserved_regions later"
>  looks okay to me.

Good, this one should go to 3.5, right?


>
> * "[PATCH] memblock: Free allocated memblock.memory.regions" makes me
>  wonder whether it would be better to have something like the
>  following instead.
>
>  typedef void memblock_free_region_fn_t(unsigned long start, unsigned size);
>
>  void memblock_free_regions(memblock_free_region_fn_t free_fn)
>  {
>        /* call free_fn() on reserved and memory regions arrays */
>        /* clear both structures so that any further usage triggers warning */
>  }

ok, will check it.

>
> * "memblock: Add checking about illegal using memblock".
>  Hmm... wouldn't it be better to be less explicit?  I think it's
>  adding too much opencoded identical checks.  Maybe implement a
>  common check & warning function?

yes.

Thanks

Yinghai
