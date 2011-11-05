Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab1KEGg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 02:36:56 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:37310 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1KEGgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 02:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=hP0pp2/dTXqSeAXHENOkEUgjpIJ+T9sh
	kLp/dQeYqLAuwawneAbMV2V+BgEcH82NJdsaZBfCHKhr+2ZwxwXg0i0cWOuK43TC
	4f8UnxCOvBWFDxPGzbArgOSleKjteY2Sx08c9DqAhGXq8AyrCWdLkCzyfxTjhug0
	Kpikc6NEU94=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Shawn Pearce <spearce@spearce.org>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org>
 <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org>
 <7vvcr1f38j.fsf@alter.siamese.dyndns.org>
 <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com>
Date: Fri, 04 Nov 2011 23:36:51 -0700
In-Reply-To: <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com> (Linus
 Torvalds's message of "Thu, 3 Nov 2011 12:09:55 -0700")
Message-ID: <7v1utn9it8.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 8C561898-0778-11E1-8F72-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Nov 3, 2011 at 11:52 AM, Junio C Hamano <gitster@pobox.com> wrote:
>>
>> Ahh, sorry for the noise. I realize that we already have a winner, namely,
>> the proposal outlined in your message I was responding to.
>
> No, no, don't consider my "put in the merge message" a winner at all.
>
> I personally dislike it, and don't really think it's a wonderful thing
> at all. I really does have real downsides:
>
>  - internal signatures really *are* a disaster for maintenance. You
> can never fix them if they need fixing (and "need fixing" may well be
> "you want to re-sign things after a repository format change")
>
>  - they are ugly as heck, and you really don't want to see them in
> 99.999% of all cases.
>
> So putting those things iin the merge commit message may have some
> upsides, but it has tons of downsides too.
>
> I think your refs/audit/ idea should be given real thought, because
> maybe that's the right idea.

While I agree that re-signing is a problem, I do not see it as a huge
issue. In your "SHA-1 to SHA-256 transtion" scenario, the conversion is a
flag day event in the hopefully fairly distant (in the git timescale)
future, and I am reasonably sure that by that time we would already have
infrastructure updates necessary to support huge number of refs, including
the "lazily scan only the refs necessary" and the "some refs are optional
in advertisement" topics that are useful for other purposes.

In the worst case, even if we used your "merge commit records the merged
tag as the record of requested pull" design today, we could choose not to
rewrite these in-merge-commit signatures when the conversion becomes
necessary. Instead, the conversion procedure can prepare a mapping table
between the old SHA-1 and the rewritten SHA-256, and contributors can
prepare detached signature for the mappings of their own commits after
verifying that the conversion produced what they are happy with. And then
we store concatenation of these detached signatures in a blob to help
future third party auditors to audit these (by-then) historical commits.

About the ugliness of the merge commit log messages, you have already
learned to ignore them with "log --no-merges" ;-) and the material the
patch series I sent out adds are at the end, so "/^commit.*$" in less
would hopefully work well enough in "log --no-merges" as well.

Because the refs/audit/ approach requires too much infrastructure we still
do not have today, and workflow elements are not fully worked out
(e.g. propagating audit trails fully from sub-sub-sub-...-lieutenants
upwards is tricky as I outlined in the other message), I think we should
start from a design that we can see how it would work now.

With the posted series, the workflow would become something like this:

  contributor$ work work work

  contributor$ git tag -s -m 'Signed pull

  This series is to allow the integrator to pull from contributors
  by specifying a signed tag, not the tip of the branch, and verify
  the authenticity of the series while merging' for-linus

  contributor$ git push public for-linus

  contributor$ git request-pull origin \
          $(git config remote.public.url) for-linus >msg
  contributor$ edit msg
  contributor$ mail torvalds@...

  integrator$ mail ;# read the pull request
  integrator$ git pull git://github.com/contributor/linux.git for-linus
   ... editor opens with the usual merge message, but with
   ... the contents of the tag and the "GPG verify" result at
   ... the end.

It might make sense to also teach the "git tag" part somehow use branch
description of the tip of branch being tagged to prime the tag message.
