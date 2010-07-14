Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0GNSaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:30:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab0GNSaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:30:02 -0400
MIME-Version: 1.0
In-Reply-To: <4C3DFED2.5000807@goop.org>
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
	<AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com>
	<4C3DF1BE.2070404@goop.org>
	<4C3DF447.1000801@zytor.com>
	<4C3DF519.6030406@goop.org>
	<4C3DF7AF.7010402@zytor.com>
	<4C3DFA88.5020007@goop.org>
	<4C3DFD12.3050700@zytor.com>
	<4C3DFED2.5000807@goop.org>
Date: Wed, 14 Jul 2010 11:23:30 -0700
Message-ID: <AANLkTiky-HhX8dz41KAgqSbHfMEc_gqo2oLpIy7f3Png@mail.gmail.com>
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
        Marcelo Tosatti <mtosatti@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:15 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> I think we should consider that deprecated and rely on dependencies and
> clobbers.

That makes no sense. According to that logic, "asm volatile" has no
semantic meaning at ALL. That's just crazy talk.

The sane compiler semantics for "asm volatile" is that it acts as a
volatile memory access. That's what the naming implies, and it has
valid semantics that also happen to match the historical semantics. It
means that it cannot be removed or duplicated, and it cannot be
re-ordered wrt other volatile accesses (whether "asm volatile" or a
traditional C volatile memory access).

I agree that we could just add memory clobbers to them all, but my
objection to that is that it just makes the whole keyword totally
pointless.

                 Linus
