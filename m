Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2L2RSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 12:18:12 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33014 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2L2RSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 12:18:10 -0500
Date: Sat, 29 Dec 2012 09:18:01 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 016/173] use clamp_t in UNAME26 fix
Message-ID: <20121229171801.GA1838@elie.Belkin>
References: <20121228190330.025298996@decadent.org.uk>
 <20121228190333.385175939@decadent.org.uk>
 <20121229080742.GD18903@elie.Belkin>
 <1356778887.4446.25.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356778887.4446.25.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Sat, 2012-12-29 at 00:07 -0800, Jonathan Nieder wrote:
>> Ben Hutchings wrote:

>>> The min/max call needed to have explicit types on some architectures
>>> (e.g. mn10300). Use clamp_t instead to avoid the warning:
>>>
>>>   kernel/sys.c: In function 'override_release':
>>>   kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>>>
>>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> [...]
>>> -		copy = min(sizeof(buf), max_t(size_t, 1, len));
>>
>> I don't understand how this happens given that v2.6.36-rc1~68
>> (MN10300: Fix size_t and ssize_t, 2010-08-12) was supposed to fix this
>> kind of thing.
> [...]
>
> Neither do I, but I'm including it now just to be consistent with other
> stable series.

Thanks for explaining.  That makes sense and the patch is harmless, so
why not.

The patch still leaves me worried that there might be more problems
lurking on mn10300, but that's more of a question for upstream.
