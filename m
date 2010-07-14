Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0GNAPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:15:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab0GNAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:15:41 -0400
MIME-Version: 1.0
In-Reply-To: <4C3CFB8B.1090804@goop.org>
References: <20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
	<20100713162207.GC15122@anguilla.noreply.org>
	<4C3C9589.4090602@redhat.com>
	<4C3C96EC.8060901@redhat.com>
	<4C3C9839.4090404@redhat.com>
	<20100713172526.GE15122@anguilla.noreply.org>
	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>
	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
	<4C3CAE8F.10900@goop.org>
	<4C3CE560.5050701@zytor.com>
	<4C3CFB8B.1090804@goop.org>
Date: Tue, 13 Jul 2010 17:15:02 -0700
Message-ID: <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Palfrader <peter@palfrader.org>,
        Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 4:49 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> The documentation makes no reference to that property; in fact it
> suggests it is outright not true:

The gcc documentation wrt inline asm's is totally worthless. Don't
even bother quoting it - because the gcc people themselves have never
cared. If the docs ever end up not matching what they want to do, they
will just change the documentation.

In other words, at least historically the docs are not in any way
meaningful. They are not a "these are the semantics we guarantee",
they are just random noise. As I mentioned, the docs historically just
said something like "will not be moved significantly", and apparently
they've been changed to be something else.

The only thing that has ever been meaningful is "this works". And, of
course, that has changed over time too, including actual
recommendations on how to make something work (as mentioned, iirc "+"
was only valid on register constraints, and "+m" used to not be
allowed _or_ recommended, these days it's the only way to do certain
things).

It's irritating, because in other circumstances, gcc people take the
reverse approach, and consider paper documentation more important than
actual implementation issues.  So sometimes they say "hey, this is the
spec", but when it comes to their own docs, the answer has
historically been "we'll just change the spec".

                         Linus
