Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0GNUvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:51:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757615Ab0GNUvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:51:08 -0400
Message-ID: <4C3E2304.5040805@zytor.com>
Date: Wed, 14 Jul 2010 13:50:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org> <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com> <4C3DF1BE.2070404@goop.org> <4C3DF447.1000801@zytor.com> <4C3DF519.6030406@goop.org> <4C3DF7AF.7010402@zytor.com> <4C3DFA88.5020007@goop.org> <4C3E1B13.5030304@redhat.com> <4C3E20B3.6020007@goop.org>
In-Reply-To: <4C3E20B3.6020007@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 01:40 PM, Jeremy Fitzhardinge wrote:
> On 07/14/2010 01:16 PM, Avi Kivity wrote:
>> On 07/14/2010 08:57 PM, Jeremy Fitzhardinge wrote:
>>> Anything else?
>>
>> 1. set up a mapping
>> 2. invlpg or set cr3
>> 3. use the mapping
>>
>> Moving the invlpg will break your code.
> 
> invlpg uses memory clobbers.  All the crX ops seem to use a
> __force_order variable to sequence them - but it looks like it's done
> precisely backwards and it's barking mad to do allow write_crX to be
> reordered with respect to memory ops.
> 
> Hm, looks like glommer added it surreptitiously while unifying
> system_32.h and system_64.h (system_32.h relied on asm volatile not
> being reordered; system_64.h used memory clobbers).
>     J

invlpg, in the general case, definitely needs a memory clobber even if
volatiles are ordered, since it needs to be ordered with regards to
non-volatile memory operations.

Note that memory clobbers don't by themselves enforce ordering since
they don't prevent the ordering of memory clobbers with respect to each
other.

	-hpa

