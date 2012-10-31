Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455Ab2JaLxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:53:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35720 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab2JaLxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <20121031032902.GD9475@thunk.org>
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
	<20121029203937.GC7098@thunk.org>
	<CAC5umyhje4oDtKzw6kYSXw99rVzZJOaeApfizGeDos3SnmUcjA@mail.gmail.com>
	<CAC5umyi=f+Q2Dxc4KS8nKd8uD3yvVNf8M9g1-nBt+6UsqSGHdg@mail.gmail.com>
	<20121031032902.GD9475@thunk.org>
Date: Wed, 31 Oct 2012 20:53:19 +0900
Message-ID: <CAC5umyjO5t6VVeSQo0V=pA3HkZEzYfTg=iVhWRje5owBWXYC8g@mail.gmail.com>
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

2012/10/31 Theodore Ts'o <tytso@mit.edu>:
> On Tue, Oct 30, 2012 at 08:12:39PM +0900, Akinobu Mita wrote:
>> >>
>> >> How about prandom32_get_bytes_state() and prandom32_get_bytes() instead?
>> >
>> > I agree with your suggestion.  I'll rename them and try again.
>> >
>> > By the way, should we also rename the existing random32() and
>> > prandom32() in the future?
>
> I suppose the other way to go is to just use random32 as the common
> prefix, and just have random32() and random32_state().  My concern was
> that people might assume that prandom32() and random32() might imply
> that only prandom32() was the one using a pseudo-random number
> generator.  This might be easier since there are large number of uses
> of random32() in the source tree, but only a relative few using
> prandom32().

Using random32 as the common prefix sounds good idea.  I'm going to
prepare the following patch set:

[patch 1] rename prandom32 to randome32_state
[patch 2] introduce random32_get_bytes and random32_get_bytes_state
[patch 3-] proliferate random32_get_bytes and random32_get_bytes_state
