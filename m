Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352Ab1J3Rli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:41:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33015 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934314Ab1J3Rlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:41:37 -0400
Message-ID: <1319996494.13597.69.camel@edumazet-laptop>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 30 Oct 2011 18:41:34 +0100
In-Reply-To: <CA+55aFyGEhBMv31QXN7q9PJc36TVtHLOvdFYB1+6NTo+nKSkbQ@mail.gmail.com>
References: <1319772566.6759.27.camel@deadeye>
	 <1319777025.23112.67.camel@edumazet-laptop>
	 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
	 <1319803781.23112.113.camel@edumazet-laptop>
	 <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
	 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
	 <1319813252.23112.122.camel@edumazet-laptop>
	 <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
	 <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
	 <1319964754.13597.26.camel@edumazet-laptop>
	 <20111030095918.GA19676@one.firstfloor.org>
	 <1319987765.13597.60.camel@edumazet-laptop>
	 <CA+55aFyGEhBMv31QXN7q9PJc36TVtHLOvdFYB1+6NTo+nKSkbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 30 octobre 2011 à 10:07 -0700, Linus Torvalds a écrit :
> On Sun, Oct 30, 2011 at 8:16 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Because it doesnt work if x is const.
> 
> Just remove the const. Problem solved.
> 
> Both cases of 'const' are totally arbitrary and useless. The
> test_bit() one is literally a cast to const (admittedly also *from*
> const, but nobody cares), and the atomic_read() one is just because it
> uses a silly inline function where a macro would be simpler.
> 

Oh well, I am lost. I always considered inline functione better because
of prototype checks.


Changing atomic_read(const atomic_t *v) prototype to
atomic_read(atomic_t *v) is not an option.


To save your time and my time, please select your favorite between :

1) The patch I did

2) 
 static inline int atomic_read(const atomic_t *v)
 {
	return ACCESS_AT_MOST_ONCE(((atomic_t *)v)->counter);
 }

3) 
 static inline int atomic_read(const atomic_t *v)
 {
	return ACCESS_AT_MOST_ONCE(*(int *)&(v)->counter);
 }

4) macro (I personnaly dont like it)
#define atomic_read(v) ACCESS_AT_MOST_ONCE(*(int *)&(v)->counter)

Thanks


