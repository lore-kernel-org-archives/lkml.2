Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1GaDSB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 23:18:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42319 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GaDRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 23:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110731024208.GA30593@khazad-dum.debian.net>
References: <20110730234630.7270.qmail@science.horizon.com>
 <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
 <CA+55aFyimDdpCRER_7pc30S-QLhUkt0z-Y=gD48f7t=FxxFh7g@mail.gmail.com>
 <CAF_S4t9PhDQBBfaLLaq1sE9YkJvQq5Q+ULegpD0aoTnv0CPutw@mail.gmail.com> <20110731024208.GA30593@khazad-dum.debian.net>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 30 Jul 2011 23:17:14 -0400
Message-ID: <CAF_S4t-a0NXa4Zapwf-jO4TRnEjpHzqFpy4HT4jE=gGwT9+80Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 22:42, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 30 Jul 2011, Bryan Donlan wrote:
>> In any case though, what about my suggestion - don't mess with urandom
>> at all, and let udev replace the /dev/urandom device node with one
>> directed to a fast hwrng device if one is detected? This has zero
>
> Now, THAT would be unsafe, and a nasty way to go about it.

I don't see why it's unsafe. It's leaving the policy decision of what
RNG to use up to userspace, without needing to introduce any new API
or parameter to do so. As long as the replacement device exposes the
same interface as /dev/urandom, no problem, right? Userspace programs
shouldn't notice the difference unless they stat() /dev/urandom and
look at the device numbers.

I do realize it's a bit unorthodox to replace what has, traditionally,
been a fixed device node with a configurable symlink, but there's no
technical reason (as far as I can see) why it shouldn't work.

> If you really don't want to touch /dev/.random, make it simple: either
> export the embedded RNG as high-bandwidth /dev/hwrandom and let
> userspace postprocess it and reroute it back to /dev/random as needed,
> or do the same with a kernel thread.

This approach is identical to mine as far as the kernel is concerned :)
You'd set up a daemon to pump entropy into /dev/random. Users who want
/dev/urandom to be even faster/more secure(?) can further symlink
/dev/urandom to /dev/hwrandom. But there's no need to change
/dev/urandom's implementation in the kernel to redirect it to the
hwrng when userspace can do that just as well on its own, is my point.
