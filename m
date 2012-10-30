Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2J3LMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:12:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45204 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2J3LMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umyhje4oDtKzw6kYSXw99rVzZJOaeApfizGeDos3SnmUcjA@mail.gmail.com>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
	<20121029203937.GC7098@thunk.org>
	<CAC5umyhje4oDtKzw6kYSXw99rVzZJOaeApfizGeDos3SnmUcjA@mail.gmail.com>
Date: Tue, 30 Oct 2012 20:12:39 +0900
Message-ID: <CAC5umyi=f+Q2Dxc4KS8nKd8uD3yvVNf8M9g1-nBt+6UsqSGHdg@mail.gmail.com>
Subject: Re: [PATCH 1/9] random32: introduce random32_get_bytes() and prandom32_get_bytes()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Akinobu Mita <akinobu.mita@gmail.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 Akinobu Mita <akinobu.mita@gmail.com>:
> 2012/10/30 Theodore Ts'o <tytso@mit.edu>:
>> On Sun, Oct 28, 2012 at 04:18:58PM +0900, Akinobu Mita wrote:
>>>  /**
>>> + *   prandom32_get_bytes - get the requested number of pseudo-random bytes
>>> + *   @state: pointer to state structure holding seeded state.
>>> + *   @buf: where to copy the pseudo-random bytes to
>>> + *   @bytes: the requested number of bytes
>>> + *
>>> + *   This is used for pseudo-randomness with no outside seeding.
>>> + *   For more random results, use random32_get_bytes().
>>> + */
>>> +
>>> +/**
>>> + *   random32_get_bytes - get the requested number of pseudo-random bytes
>>> + *   @buf: where to copy the pseudo-random bytes to
>>> + *   @bytes: the requested number of bytes
>>> + */
>>
>> This naming scheme is going to be very confusing.  If the function is
>> going to return a pseudo-random number, it *must* have a "prandom"
>> suffix.  Otherwise some kernel developer, somewhere, will get confused
>> between get_random_bytes() and random32_get_bytes(), and the result
>> may be a very embarassing security exposure.
>>
>> How about prandom32_get_bytes_state() and prandom32_get_bytes() instead?
>
> I agree with your suggestion.  I'll rename them and try again.
>
> By the way, should we also rename the existing random32() and
> prandom32() in the future?
>
> Specifically, rename random32() to prandom32(), and prandom32() to
> prandom32_state().  As a result, it will cause a little confusion
> between old and new prandom32(). But the number of arguments will
> be changed from 3 to 2, so gcc can detect the misuse of prandom32().

Oops, I intended to say "the number of arguments of prandom32() will be
changed from 1 to 0". And I realized that the exisiting srandom32() also should
be renamed to sprandom32().
