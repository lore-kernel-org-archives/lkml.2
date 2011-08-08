Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1HHHPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:15:16 -0400
Received: from gw1.transmode.se ([195.58.98.146]:35340 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1HHHPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:15:15 -0400
In-Reply-To: <026801cc5394$f54f6c70$dfee4550$@systemfabricworks.com>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com> <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se> <019501cc52d7$c8688100$59398300$@systemfabricworks.com> <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se> <026801cc5394$f54f6c70$dfee4550$@systemfabricworks.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 25F52230:48CE6182-C12578E6:0027AE16;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF25F52230.48CE6182-ONC12578E6.0027AE16-C12578E6.0027D876@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 09:15:13 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 09:15:13
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/05 19:27:26:
>
> > >
> > > >
> > > > >
> > > > > Modify all 'i' loops from for (i = 0; i < foo; i++) { ... } to for
> (i =
> > > foo
> > > > > - 1; i >= 0; i--) { ... }
> > > >
> > > > That should be (i = foo; i ; --i) { ... }
> > >
> > > Shouldn't make much difference, branch on zero bit or branch on sign
> bit.
> > > But at the end of the day didn't help on Nehalem.
>
> I figured out why "for (i = 0; i < len; i++) {...}" is faster than "for (;
> len; len--) {...}" on my system.
> The current code is
>
> for (; Ien; len--) {
>    load *++p
>    ...
> }
>
> Which turns into (in fake assembly)
>
> top:
>    dec len
>    inc p
>    load p
>    ...
>    test len
>    branch neq top
>
> But when I replace that with
>
> for(i = 0; i < len; i++) {
>    load *++p
>    ...
> }
>
> Gcc turns it into
>
> top:
>    load p[i]
>    i++
>    ...
>    compare i, len
>    branch lt top
>
> which is fewer instructions and i++ is well scheduled. Incrementing the
> pointer has been moved out of the loop.

I see. Lets leave the pre vs. post inc. for now. That is something
that can be sorted separately.

 Jocke

