Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2BFBZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:25:04 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57512 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2BFBZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:25:03 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzPiy5RB+B70gPGX7sSJvcwqHuwL9F=SGMZBG58CuX9pQ@mail.gmail.com>
References: <4F2EED22.3070901@t-online.de>
	<CA+55aFzPiy5RB+B70gPGX7sSJvcwqHuwL9F=SGMZBG58CuX9pQ@mail.gmail.com>
Date: Mon, 6 Feb 2012 09:25:01 +0800
X-Google-Sender-Auth: Q_l69mszp885eZrfA7yeIXxm6gE
Message-ID: <CANejiEWBdL4G3qt4=qjzakkokt1xbmcRXFS15EFt3bnSsvkCMA@mail.gmail.com>
Subject: Re: [BUG 3.3-rc2] spinlock trylock failure on UP on CPU#0
From: Shaohua Li <shaohua.li@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/6 Linus Torvalds <torvalds@linux-foundation.org>:
> Ok, interesting. You're triggering the issue because you have a UP
> build with the spinlock debugging code enabled.
>
> On Sun, Feb 5, 2012 at 12:57 PM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
>> Booting  23783f817bceedd6d4e549385e3f400ea64059e5 I get the following trace
>> an AOpen i915GMm-hfs with Pentium-M Dothan:
>
> This is probably the same "technically legal" code that LOCKDEP also
> is unhappy about - the nested fast path release. We do a trylock on
> the queue lock while we already are holding the queue lock
> recursively.
>
> Jens, Tejun - the crazy-ass games that this code is playing is clearly
> messing not just with lockdep, it's messing with some very reasonable
> spinlock sanity checks on UP (which just boil down to "a spinlock
> should never have contention on UP")
>
> Any chance of sanitizing this all?
I just sent out a debug patch, please try:
http://marc.info/?l=linux-kernel&m=132849146702770&w=2
