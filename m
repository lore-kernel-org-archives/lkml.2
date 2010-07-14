Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0GNRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:31:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0GNRbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:31:40 -0400
Message-ID: <4C3DF447.1000801@zytor.com>
Date: Wed, 14 Jul 2010 10:30:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org> <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com> <4C3DF1BE.2070404@goop.org>
In-Reply-To: <4C3DF1BE.2070404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 10:19 AM, Jeremy Fitzhardinge wrote:
> On 07/13/2010 05:15 PM, Linus Torvalds wrote:
>> The gcc documentation wrt inline asm's is totally worthless. Don't
>> even bother quoting it - because the gcc people themselves have never
>> cared. If the docs ever end up not matching what they want to do, they
>> will just change the documentation.
>>
>> In other words, at least historically the docs are not in any way
>> meaningful. They are not a "these are the semantics we guarantee",
>> they are just random noise. As I mentioned, the docs historically just
>> said something like "will not be moved significantly", and apparently
>> they've been changed to be something else.
> 
> Sure, I completely agree.  At the moment the docs say "asm volatile
> guarantees nothing", and we can work with that.  So long as we don't
> expect asm volatile to mean anything more (ie, magic semantics involving
> reordering), everyone is happy.

Except we do.

> BTW, gcc 2.95's docs do mention "asm volatile" having an effect on
> ordering, which is probably where the notion came from: "If you write an
> `asm' instruction with no outputs, GNU CC [...] not delete the
> instruction or move it outside of loops. [...] you should write the
> `volatile' keyword to prevent future versions of GNU CC from moving the
> instruction around within a core region".  Lucky we never relied on
> that, right?  Right?

If gcc ever starts reordering volatile operations, including "asm
volatile", the kernel will break, and will be unfixable.  Just about
every single driver will break.  All over the kernel we're explicitly or
implicitly making the assumption that volatile operations are strictly
ordered by the compiler with respect to each other.

	-hpa
