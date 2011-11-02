Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1KBUEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:04:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54456 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1KBUEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <7vk47jld5s.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Nov 2011 13:04:30 -0700
X-Google-Sender-Auth: _zKSswQEQMX8QTtG301TtzynOoo
Message-ID: <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 2:56 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> But on the other hand, in many ways, publishing your commit to the outside
> world, not necessarily for getting pulled into the final destination
> (i.e. your tree) but merely for other people to try it out, is the point
> of no return (aka "don't rewind or rebase once you publish").  "pushing
> out" might be less special than "please pull", but it still is special.

So I really think that signing the top commit itself is fundamentally wrong.

That commit may not even be *yours*. You may have pulled it from a
sub-lieutenant as a fast-forward, or similar. Amending it later would
be actively very very *wrong*.

So quite frankly, I think the stuff in pu (or next?) is completely
mis-designed. Doing it in the commit is wrong for fundamental reasons,
which all boil down to a simple issue:

 - you absolutely *need* to add the signature later. You *cannot* do
it at "git commit" time.

That's a fundamental issue both from a "workflow model" issue (ie you
want to sign stuff after it has passed testing etc, but you may need
to commit it in order to *get* testing), as well as from a
"fundamental git datastructures" issue (ie you would want to sign
commits that aren't yours.

"git commit --amend" is not the answer - that destroys the fundamental
concept of history being immutable, and while it works for your local
commits, it doesn't work for anybody elses commits, or for stuff you
already pushed out.

And "add a fake empty commit just for the signature" is not the answer
either - because that is clearly inferior to the tags we already had.

I dunno. Did I miss something? As far as I can tell, the signed tags
that we've had since day one are *clearly* much better in very
fundamental ways.

                             Linus
