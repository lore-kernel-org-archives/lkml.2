Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0GNVL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:11:28 -0400
Received: from claw.goop.org ([74.207.240.146]:46836 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0GNVLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:11:24 -0400
Message-ID: <4C3E27FB.8000808@goop.org>
Date: Wed, 14 Jul 2010 14:11:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org> <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com> <4C3DF1BE.2070404@goop.org> <4C3DF447.1000801@zytor.com> <4C3DF519.6030406@goop.org> <4C3DF7AF.7010402@zytor.com> <4C3DFA88.5020007@goop.org> <4C3E1B13.5030304@redhat.com> <4C3E20B3.6020007@goop.org> <4C3E21D1.3010207@redhat.com>
In-Reply-To: <4C3E21D1.3010207@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 01:45 PM, Zachary Amsden wrote:
> clts() has no memory clobber; it is used to serialize execution of
> code within kernel_fpu_begin() / kernel_fpu_end() blocks.
>
> If the code within is reordered before the clts(), we've corrupted
> guest FPU state.

Hm, that's awkward - you'd really need some way of specifying ordering
with respect to the FPU state, and "memory" would only be an approximate
proxy of that.  And not a good one, since gcc wouldn't regard
register-only fpu ops as being affected by a memory clobber.

    J
