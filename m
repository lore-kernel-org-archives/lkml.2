Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1KMQio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 11:38:44 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:51486 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab1KMQin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 11:38:43 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dedekind1@gmail.com, David Woodhouse <dwmw2@infradead.org>
Cc: Mike Dunn <mikedunn@newsguy.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ivan Djelic <ivan.djelic@parrot.com>
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
	<1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>
	<4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
	<1321188825.2273.4.camel@koala>
	<1321189398.2021.5.camel@shinybook.infradead.org>
	<1321191352.2273.14.camel@koala>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 13 Nov 2011 17:38:31 +0100
In-Reply-To: <1321191352.2273.14.camel@koala> (Artem Bityutskiy's message of
	"Sun, 13 Nov 2011 15:35:49 +0200")
Message-ID: <87ehxchta0.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> What Robert says is that we probably need an is_page_blank() and let the
> driver implement it optimally, or make MTD fall-back to 0xFFs
> comparison.
>
> This is my understanding.
And that's exactly my point.

And while we're discussing MTD API, I'd like to add another thing I was thinking
of, from a conversation Mike and Ivan had.

They discussed how UBIFS is "intolerant" to bitflips, and marks a block as
"unusable" if one bitflip occured, even if the ECC can fix much more.

What I was thinking is that the MTD oob information which exposes how many ECC
are available should expose as well how many bitflips can be fixed (for example
4 bitflips can be fixed, 5 bitflips can be detected). Then, the read_oob()
function could return back 0 if read was successful, -Exxxx on error, or a
positive number N if N bitflips were fixed.
With this information, upper level could decide from (read_oob() return and
ecc.fixable_bitflips) if a block should be marked as unusable (worn out) or not.

I'd like some feedback on this idea as well.

Cheers.

--
Robert
