Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab1KDXLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:11:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64004 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1KDXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <7v39e3bn1n.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <CA+55aFzstE-+NzfSAWMEokB7-rYsZOcZe9Ez-LxPNOKnciJ3UQ@mail.gmail.com>
 <7vlirvbq47.fsf@alter.siamese.dyndns.org> <7v39e3bn1n.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Nov 2011 16:10:59 -0700
X-Google-Sender-Auth: 4ALveBQpD7ONZ_LX_QgLc0Bu1to
Message-ID: <CA+55aFzKPPqwGOe5Ov0FHF1DHbKmNhm=ePvcaY5uqR7cwFhQGQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Junio C Hamano <junio@pobox.com>
Cc: git@vger.kernel.org, Shawn Pearce <spearce@spearce.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 2:22 PM, Junio C Hamano <junio@pobox.com> wrote:
>
> builtin/merge.c was updated to use want_commit() that uses peel_to_type()
> to commit to make sure we do not get fed anything funky, and also uses
> struct commit_list to pass around list of parents to be recorded, so we
> should be OK in this department.

I'm pretty sure people have already done "git merge v3.1" kind of
things using local tags (where no peeling of FETCH_HEAD has been
done). See

    git log --merges --grep 'Merge.*v[23]\.[0-9]'

for a ton of examples of this (and there's something odd going on: we
have "Merge commit .." and "Merge tag ..", and I suspect the latter is
people editing it to be correct by hand, but I dunno).

So this has always worked, methinks.

However - exactly beause git apparently makes it do that "Merge commit
" message, I suspect we've peeled things too early and too much. We've
peeled it so early that once again something thinks it's a commit, not
a tag.

So if anything, I suspect "git merge" not only peels, but peels too
much (or at the wrong point). We should probably peel as late as
possible.

But it's a small detail.

                  Linus
