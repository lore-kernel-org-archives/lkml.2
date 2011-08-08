Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HHHLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:11:42 -0400
Received: from gw1.transmode.se ([195.58.98.146]:45278 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1HHHLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:11:41 -0400
In-Reply-To: <023b01cc5387$79b09dd0$6d11d970$@systemfabricworks.com>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com> <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se> <019501cc52d7$c8688100$59398300$@systemfabricworks.com> <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se> <023b01cc5387$79b09dd0$6d11d970$@systemfabricworks.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 82B0126C:84721F7A-C12578E6:0027546F;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF82B0126C.84721F7A-ONC12578E6.0027546F-C12578E6.00278492@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 8 Aug 2011 09:11:38 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/08/2011 09:11:38
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/05 17:51:00:
>
> > > version. While I haven't done the experiment you suggest there is
> > something
> > > to the point that the second q computation in the new version can be
> > moved
> > > ahead of the table lookups from the first q computation . My guess is
> that
> > > the unrolled version will be significantly slower.
> >
> > Ah, didn't see that. Don't understand how this works though.
> > Why do you do two 32 bit loads instead of one 64 bit load?
> >
> > >
>
> The two expression trees can be computed in parallel and combined with the
> final xor. If the compiler/instruction scheduler are smart enough and can
> process enough instructions per cycle they overlap well and you get some
> speedup. I did try a 64 bit load on Nehalem but got about 2 cycles per byte
> which is a little worse than doing two loads and better than the 32 bit
> version. I'm not really sure why.

I see. There is one thing that strikes me as a bit odd. Why do 8 byte alignment
when you do 32 bit accesses? Surely the current 4 byte alignment will do?

 Jocke

