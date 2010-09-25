Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0IYVeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 17:34:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580Ab0IYVeA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:34:00 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikEVr6wA6D_f2Z6OEFu6SCP_-89u0-k-K-wKgb=@mail.gmail.com>
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
 <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk>
 <AANLkTikEVr6wA6D_f2Z6OEFu6SCP_-89u0-k-K-wKgb=@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Sep 2010 14:33:36 -0700
Message-ID: <AANLkTind6v89k6eG=fx=G21-CH=Km-HsRL_cx85uz65x@mail.gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
To: Al Viro <viro@zeniv.linux.org.uk>, Matt Turner <mattst88@gmail.com>
Cc: rth@twiddle.net, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaah. This got bounced, because that idiotic android gmail client
sends emails out as html even though they are just plain text. And
lkml (correctly) thinks that html emails are likely to be spam and
useless.

Too bad. I like being able to pen some replies on the road, and
android is pretty good at it otherwise.

Btw Al, I just noticed that you only cc'd me and rth. These days, for
alpha stuff, you probably should have added at least Matt Turner to
the cc too. I don't think Richard has been active in the alpha
community for many years now.

Matt - see the whole discussion on lkml (or I can forward you the
emails, if you want to).

                    Linus

On Sat, Sep 25, 2010 at 1:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I think it's not only UP-only, I think it ends up being an issue only on
> really old machines.
>
> The newer alpha's have byte/word operations and thus have enough physical
> address space to just map all the IO in at the same time. It was only the
> old crappy alphas that needed the whole windowing thing due to the whole
> silly "encode operand size in the address" thing.
>
> But I forget exactly where the cut-off point is.
>
>          Linus
>
> On Sep 25, 2010 12:26 PM, "Al Viro" <viro@zeniv.linux.org.uk> wrote:
>>
>> BTW, am I right assuming that HAE modifications is UP-only thing? It would
>> be obviously b0rken on any SMP box, since alpha_mv is not per-CPU thing...
>
