Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab1J3RH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:07:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42745 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab1J3RH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <1319987765.13597.60.camel@edumazet-laptop>
References: <1319772566.6759.27.camel@deadeye> <1319777025.23112.67.camel@edumazet-laptop>
 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
 <1319803781.23112.113.camel@edumazet-laptop> <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
 <1319813252.23112.122.camel@edumazet-laptop> <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
 <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
 <1319964754.13597.26.camel@edumazet-laptop> <20111030095918.GA19676@one.firstfloor.org>
 <1319987765.13597.60.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Oct 2011 10:07:36 -0700
X-Google-Sender-Auth: XjEflSyPa8HPA-XQZxllkqufXro
Message-ID: <CA+55aFyGEhBMv31QXN7q9PJc36TVtHLOvdFYB1+6NTo+nKSkbQ@mail.gmail.com>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 8:16 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Because it doesnt work if x is const.

Just remove the const. Problem solved.

Both cases of 'const' are totally arbitrary and useless. The
test_bit() one is literally a cast to const (admittedly also *from*
const, but nobody cares), and the atomic_read() one is just because it
uses a silly inline function where a macro would be simpler.

                              Linus
