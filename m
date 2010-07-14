Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0GNSJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:09:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34023 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0GNSJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:09:43 -0400
Message-ID: <4C3DFD12.3050700@zytor.com>
Date: Wed, 14 Jul 2010 11:08:18 -0700
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
        Marcelo Tosatti <mtosatti@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org> <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com> <4C3DF1BE.2070404@goop.org> <4C3DF447.1000801@zytor.com> <4C3DF519.6030406@goop.org> <4C3DF7AF.7010402@zytor.com> <4C3DFA88.5020007@goop.org>
In-Reply-To: <4C3DFA88.5020007@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding H.J. to the Cc: list]

On 07/14/2010 10:57 AM, Jeremy Fitzhardinge wrote:
>>>     
>> I/O ports, for example.
>>   
> 
> Yes, it looks like they should have memory barriers if we want them to
> be ordered with respect to normal writes; afaict "asm volatile" has
> never had strict ordering wrt memory ops.
> 

Noone has talked about strict ordering between volatiles and
(non-volatile) memory ops in general.  I have been talking about
volatile to volatile ordering, and I thought I'd been very clear about that.

H.J., we're having a debate about the actual semantics of "volatile",
especially "asm volatile" in gcc.  In particular, I believe that
volatile operations should not be possible to reorder with regards to
each other, and the kernel depends on that fact.

	-hpa

P.S: gcc 4.4 seems to handle "const volatile" incorrectly, probably by
applying CSE to those values.

