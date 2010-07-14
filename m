Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0GNSVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:21:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39419 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab0GNSVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JHOG2sZF5f/XSHs8XSPjyyMSz/vycs3C1OlzQJVvYEoykPbU/Ff80qj1NeYN4q55HY
         21U9Rx22oudt+bMLYaq7fHDIHyy7jD0O07extpsANs9iaKIA/a/fTQ4Q1P8DhWsN2xGe
         fn4SZN7jCwZFQLtArERydlCgKsx2YO/9BvTog=
MIME-Version: 1.0
In-Reply-To: <4C3DFD12.3050700@zytor.com>
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
Date: Wed, 14 Jul 2010 11:18:23 -0700
Message-ID: <AANLkTikA8SO42kOgHZb-6YuhM7GPnmg81IAX5vEk_Cqk@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 11:08 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> [Adding H.J. to the Cc: list]
>
> On 07/14/2010 10:57 AM, Jeremy Fitzhardinge wrote:
>>>>
>>> I/O ports, for example.
>>>
>>
>> Yes, it looks like they should have memory barriers if we want them to
>> be ordered with respect to normal writes; afaict "asm volatile" has
>> never had strict ordering wrt memory ops.
>>
>
> Noone has talked about strict ordering between volatiles and
> (non-volatile) memory ops in general.  I have been talking about
> volatile to volatile ordering, and I thought I'd been very clear about that.
>
> H.J., we're having a debate about the actual semantics of "volatile",
> especially "asm volatile" in gcc.  In particular, I believe that
> volatile operations should not be possible to reorder with regards to
> each other, and the kernel depends on that fact.
>
>        -hpa
>
> P.S: gcc 4.4 seems to handle "const volatile" incorrectly, probably by
> applying CSE to those values.
>
>

There are some discussions on:

http://gcc.gnu.org/ml/gcc-patches/2010-06/msg02001.html
http://gcc.gnu.org/ml/gcc-patches/2010-07/msg00001.html

Are they related?


-- 
H.J.
