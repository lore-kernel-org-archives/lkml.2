Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1KCCUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:20:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33156 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1KCCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:19:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com> <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Nov 2011 19:19:34 -0700
X-Google-Sender-Auth: c8vKjHN7EXcXXLSbTOuCdUh90I8
Message-ID: <CA+55aFzstE-+NzfSAWMEokB7-rYsZOcZe9Ez-LxPNOKnciJ3UQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Shawn Pearce <spearce@spearce.org>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e6dbde156db06504b0cb39bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dbde156db06504b0cb39bc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 2, 2011 at 6:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> =A0 [torvalds@i5 linux]$ git fetch git://github.com/rustyrussell/linux.gi=
t  refs/tags/rusty@rustcorp.com.au-v3.1-8068-g5087a50

So this trivial patch removes one line of code, and makes this actually wor=
k.

However, it also makes us fail many tests that *test* that we peeled
what we fetched. However, I think the tests are wrong.

If the tag doesn't resolve into a commit, we happily output the SHA1
of the tag itself - and we say that it shouldn't be merged.

And it the tag *does* resolve into a commit, why would we output the
SHA1 of the commit? The tag should be peeled properly later when it
gets used, so peeling it here seems to be just a misfeature that makes
signed tags not work well.

So I suspect we should just apply this patch, but I didn't check
exacty what the failed tests are - except for the first one, that just
compares against a canned response (and the canned response should
just be changed). Maybe there was some reason for the peeling,
although I suspect it was just a fairly mindless case of "make it a
commit, because the merge needs the commit" - never mind that the
merge would peel it anyway.

                           Linus

--0016e6dbde156db06504b0cb39bc
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_guj4n2ba0

IGJ1aWx0aW4vZmV0Y2guYyB8ICAgIDMgKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9idWlsdGluL2ZldGNoLmMgYi9idWls
dGluL2ZldGNoLmMKaW5kZXggOTE3MzFiOTA5YWViLi40OTRhN2Y5OTc2ZjggMTAwNjQ0Ci0tLSBh
L2J1aWx0aW4vZmV0Y2guYworKysgYi9idWlsdGluL2ZldGNoLmMKQEAgLTQzNiw4ICs0MzYsNyBA
QCBzdGF0aWMgaW50IHN0b3JlX3VwZGF0ZWRfcmVmcyhjb25zdCBjaGFyICpyYXdfdXJsLCBjb25z
dCBjaGFyICpyZW1vdGVfbmFtZSwKIAkJfQogCQlub3RlW25vdGVfbGVuXSA9ICdcMCc7CiAJCWZw
cmludGYoZnAsICIlc1x0JXNcdCVzIiwKLQkJCXNoYTFfdG9faGV4KGNvbW1pdCA/IGNvbW1pdC0+
b2JqZWN0LnNoYTEgOgotCQkJCSAgICBybS0+b2xkX3NoYTEpLAorCQkJc2hhMV90b19oZXgocm0t
Pm9sZF9zaGExKSwKIAkJCXJtLT5tZXJnZSA/ICIiIDogIm5vdC1mb3ItbWVyZ2UiLAogCQkJbm90
ZSk7CiAJCWZvciAoaSA9IDA7IGkgPCB1cmxfbGVuOyArK2kpCg==
--0016e6dbde156db06504b0cb39bc--
