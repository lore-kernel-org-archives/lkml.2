Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855Ab0KQEaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:30:01 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51104 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab0KQE36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:29:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lclh9yUFC1DXDvJj1PllCcZwwfRwXt2zbMEkuOJ2L+w4yMMbzC6tao+JCvymdPNArr
         F+RezL1Ho3w7J8JxaaWBQB5LO5o8tEy05Nj1VB+lcBJoO+N5w6RU3n5iEIPJxhPZUYmd
         HoCqYpaJYewEnFulBbw6p6Llb2qiKozgzrOTA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimQtXeCE1Gu4YuPBBZ_J3ieW6Z5JtvzF=hF7pWX@mail.gmail.com>
References: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
	<AANLkTimQtXeCE1Gu4YuPBBZ_J3ieW6Z5JtvzF=hF7pWX@mail.gmail.com>
Date: Tue, 16 Nov 2010 23:29:57 -0500
Message-ID: <AANLkTinz27cfdNKEtyUo9f3nuw+XbZ2Osz0ThRiOQnnL@mail.gmail.com>
Subject: Re: Behavior of BUG() [Was: Re: [PATCH 2/5] of/fdt: add kernel
 command line option for dtb_compat string]
From: Arnaud Lacombe <lacombar@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 16, 2010 at 11:13 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Tue, Nov 16, 2010 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Hi,
>>
>> [CC: list reduced as starting a new thread, most on the context
>> removed as this concern a different issue.]
>>
>> On Tue, Nov 16, 2010 at 7:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>> On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
>>>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>>> [...]
>>> The kernel needs to complain *loudly* if this occurs because it
>>> represents a bug.  I'm tempted to say use BUG, but that would halt the
>>> kernel and prevent any possibility of kernel log output.
>>> [...]
>> does it ? if CONFIG_BUG is not enabled and the arch has no define for
>> it, the default does _nothing_:
>>
>> from `include/asm-generic/bug.h':
>>
>> #else /* !CONFIG_BUG */
>> #ifndef HAVE_ARCH_BUG
>> #define BUG() do {} while(0)
>> #endif
>>
>> #ifndef HAVE_ARCH_BUG_ON
>> #define BUG_ON(condition) do { if (condition) ; } while(0)
>> #endif
>> [...]
>>
>> gcc is triggering about ~30 warnings (like [0]) on code path using
>> BUG(). Most of these path assume BUG() will never return, which is not
>> true.
>
> As far as I know, BUG() is not supposed to return.  Period.
>
but the code I pointed out _do_ return.

> The patch
> below is part of the linux-tiny work, and should only ever be used on
> embedded systems where small size is more important than debugability.
>
AFAIK, this is not precised anywhere, but I may not have search enough.

Matt, any reason the generic code does not just spin (or OOPS) and
marked __noreturn in any case ?

 - Arnaud
