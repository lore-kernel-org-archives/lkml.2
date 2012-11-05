Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2KEQOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:14:10 -0500
Received: from smtp208.alice.it ([82.57.200.104]:44854 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab2KEQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:14:03 -0500
Date: Mon, 5 Nov 2012 17:13:48 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: nouveau, linux3.7-rc3: BUG: unable to handle kernel paging
 request at fffffffffffffff8
Message-Id: <20121105171348.a17ec5cb5dc277a42171ca61@studenti.unina.it>
In-Reply-To: <CAPM=9tyU6yYeYBkUJHqofm2iX5BKdSA6C73O7h2iBqsrEZHr9g@mail.gmail.com>
References: <20121029231624.1476a25a62a0c219cc25627a@studenti.unina.it>
	<20121105092904.74d7ff6703f984b0b05f8e16@studenti.unina.it>
	<CAPM=9tyU6yYeYBkUJHqofm2iX5BKdSA6C73O7h2iBqsrEZHr9g@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012 08:40:38 +0000
Dave Airlie <airlied@gmail.com> wrote:

> On Mon, Nov 5, 2012 at 8:29 AM, Antonio Ospite <ospite@studenti.unina.it> wrote:
> > On Mon, 29 Oct 2012 23:16:24 +0100
> > Antonio Ospite <ospite@studenti.unina.it> wrote:
> >
> >> Hi,
> >>
> >> I am experiencing a bug with nouveau with linux-3.7-rc3 (and since rc1),
> >> my video adapter is the one integrated on the MSI M3N78-VM motherboard
> >> (hence x86_64):
> >>
> > [...]
> >> [ 1943.858601] BUG: unable to handle kernel paging request at fffffffffffffff8
> >> [ 1943.858669] IP: [<ffffffffa031a67a>] nouveau_mm_head+0x30/0x127 [nouveau]
> >> [ 1943.858779] PGD 160d067 PUD 160e067 PMD 0
> >> [ 1943.858803] Oops: 0000 [#1] SMP
> > [..]
> >> [ 1943.860018] Call Trace:
> >> [ 1943.860019]  [<ffffffff810fa13d>] ? kmem_cache_alloc_trace+0xbf/0xcf
> >> [ 1943.860019]  [<ffffffff81060f13>] ? should_resched+0x5/0x23
> >> [ 1943.860019]  [<ffffffffa032a10a>] ? nv50_fb_vram_new+0xc5/0x1f2 [nouveau]
> >
> > Ben, I cannot reproduce the crash with 3.7-rc4, I spotted commits
> > a7dbf00 and 5cad16a which seem to be related to the problem I was
> > having; would you mind elaborating a bit about what you think was
> > causing the crash on my side? Maybe the chipset used on this motherboard
> > doesn't support some feature? And how did you figured out from the logs?
> >
> 
> 5cad16acd25b16681a060d28d10eeacf98d07701 is the actual fix
> 
> The chipset hasn't got Z compression support, and the oops once decoded pointed
> out the new code was trying to allocate Z tags from a NULL memory block. The old
> code use to allocate an empty memory block instead of NULL, and it got
> lost in the
> rewrite, Ben just fixed it to allow empty memory blocks again.
> 
> Dave.
> 

Thanks a lot for the explanation.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
