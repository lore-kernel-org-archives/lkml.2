Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1JaXzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:55:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37464 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:55:09 -0400
Message-ID: <4EAF3556.3000001@garzik.org>
Date: Mon, 31 Oct 2011 19:55:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com> <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com> <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com> <4EAF2245.90308@zytor.com> <7vzkggok6u.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vzkggok6u.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 06:44 PM, Junio C Hamano wrote:
> "H. Peter Anvin"<hpa@zytor.com>  writes:
>
>> On 10/31/2011 03:30 PM, Linus Torvalds wrote:
>>>
>>> But if you do the normal "git pull git://git.kernel.org/name/of/repo"
>>> - which is how things happen as a result of a pull request - you won't
>>> get tags at all - you have to ask for them by name or use "--tags" to
>>> get them all.
>>>
>>
>> Didn't realize that... I guess I'm too used to named remotes.
>>
>> If so, just using a tag should be fine, no?
>
> So nobody is worried about this (quoting from my earlier message)?
>
>     On the other hand, the consumers of "Linus kernel" may want to say that
>     they trust your tree and your tags because they can verify them with your
>     GPG signature, but also they can independently verify the lieutenants'
>     trees you pulled from are genuine.
>
> A signed emphemeral tag is usable as means to verify authenticity in a
> hop-by-hop fashion, but that does not leave a permanent trail that can be
> used for auditing.

The main worry is Linus ($human_who_pulls) gets 
cryptographically-verified data at the time he pulls.  Once Linus 
republishes his tree (git push), there will be few, if any, wanting to 
verify Jeff Garzik's signature.

So no, I don't see that as a _driving_ need in the kernel's case.

And IMO the kernel will be a mix of signed and unsigned content for a 
while, possibly forever.


And Linus wrote:
> [ Example gpg-signed small block that the attached patch adds to the
> pull request: ]
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Commit be3fa9125e708348c7baf04ebe9507a72a9d1800
> from git.kernel.org/pub/git
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
>
> iQEcBAEBAgAGBQJOrsILAAoJEHm+PkMAQRiGxZcH/31e0RrBitXUPKxHJajD58yh
> SIEe/7i6E2RUSFva3KybEuFslcR8p8DYzDQTPLejStvnkO8v0lXu9s9R53tvjLMF
> aaQXLOgrOC2RqvzP4F27O972h32YpLBkwIdWQGAhYcUOdKYDZ9RfgEgtdJwSYuL+
> oJ7TjLrtkcILaFmr9nYZC+0Fh7z+84R8kR53v0iBHJQOFfssuMjUWCoj9aEY12t+
> pywXuVk2FsuYvhniCAcyU6Y1K9aXaf6w5iOY2hx/ysXtUBnv92F7lcathxQkvgjO
> fA7/TXEcummOv5KQFc9vckd5Z1gN2ync5jhfnmlT2uiobE6mNdCbOVlCOpsKQkU=
> =l5PG
> -----END PGP SIGNATURE-----


This is my preference for kernel pull requests at the moment.  That has 
one advantage over Junio's "git pull --require-signature" and signed 
commits, notably, the URL is signed.

But in general signed commits would be nice, too.  pull-generated merge 
requests would need to be signed, potentially introducing an additional 
interactive step (GPG passphrase request) into an automated process.

	Jeff


