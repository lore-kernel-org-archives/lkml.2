Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1IMMTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1IMMTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:19:01 -0400
Message-ID: <4E6F4A20.9000100@redhat.com>
Date: Tue, 13 Sep 2011 08:18:40 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steve Grubb <sgrubb@redhat.com>,
        Sandy Harris <sandyinchina@gmail.com>,
        Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>  <201109080911.12921.sgrubb@redhat.com>  <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>  <201109090904.18321.sgrubb@redhat.com>  <alpine.LFD.2.02.1109092241390.2723@ionos> <4E6E0F90.4090905@redhat.com> <1315911509.5977.1.camel@twins>
In-Reply-To: <1315911509.5977.1.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2011-09-12 at 09:56 -0400, Jarod Wilson wrote:
>> Thomas Gleixner wrote:
>
>>> Well, there is enough prove out there that the hardware you're using
>>> is a perfect random number generator by itself.
>>>
>>> So stop complaining about not having access to TPM chips if you can
>>> create an entropy source just by (ab)using the inherent randomness of
>>> modern CPU architectures to refill your entropy pool on the fly when
>>> the need arises w/o imposing completely unintuitive thresholds and
>>> user visible API changes.
>> We started out going down that path:
>>
>> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05778.html
>>
>> We hit a bit of a roadblock with it though.
>
> Have you guys seen this work:
>
>    http://lwn.net/images/conf/rtlws11/random-hardware.pdf

Yeah, that was part of the initial inspiration for the prior approach. 
There were still concerns that clock entropy didn't meet the random 
entropy pool's "perfect" security design goal. Without a rewrite of the 
entropy accounting system, clock entropy isn't going in, so I think 
looking into said rewrite is up next on my list.

-- 
Jarod Wilson
jarod@redhat.com


