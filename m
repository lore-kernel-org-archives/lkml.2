Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab1J3RNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:13:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab1J3RNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1319969101.5215.20.camel@dabdike>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Oct 2011 10:12:54 -0700
X-Google-Sender-Auth: T3mbP0UJk84UDDqm_l8h2ZpwIHM
Message-ID: <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 3:05 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> You can fix this by using mime and detached signatures as well but I
> wouldn't worry too much about it.  What emerged at KS is that Linus uses
> gmail and gmail has no integration with pgp, thus pgp signing of pull
> requests is superfluous since Linus won't add the steps of saving the
> message to a text file and manually running pgp over it to verify
> because of the huge elongation in workflow this causes especially during
> a merge window.

Actually, I have been running "gpg --verify" on the email that use the
standard PGP encapsulation (ie the kind that Jeff used, that has
"-----BEGIN PGP SIGNED MESSAGE-----" in it.

It's the rfc3516-type email (aka protocol="application/pgp-encrypted")
type that I can't even verify, because that's not something that gpg
knows inherently how to check: you have to decode the message the
right way and know what the rules are, and I have no intention of
trying to figure it out. I have yet to find any usable tool that is
able to check it, and I'm certainly not going to waste time trying to
parse the rfc and write my own.

That said, even the "BEGIN PGP SIGNED MESSAGE" things are a massive
pain in the butt. We need to automate this some sane way, both for the
sender and for the recipient.

                                      Linus
