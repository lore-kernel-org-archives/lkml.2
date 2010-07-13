Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab0GMWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:18:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35349 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab0GMWSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:18:36 -0400
Message-ID: <4C3CE560.5050701@zytor.com>
Date: Tue, 13 Jul 2010 15:14:56 -0700
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
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com> <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com> <4C3CAE8F.10900@goop.org>
In-Reply-To: <4C3CAE8F.10900@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 11:21 AM, Jeremy Fitzhardinge wrote:
> 
> "asm volatile"'s only real meaning is that it will not get elided if it
> appears its output is unused (assuming it is reachable at all).  I don't
> think you can consider it having any meaningful effects on ordering.
> 

Actually, I believe volatile operations (including asm volatile) are
strictly ordered *with respect to other volatile operations*.  As such I
would think we'd want to keep the "memory" clobber here, to make it
strictly ordered with regards to *all* memory operations.

As for the concept in this patch, it's obviously the right thing, but as
Linus said elsewhere it's incomplete.

Conceptually:

Acked-by: H. Peter Anvin <hpa@zytor.com>

Unfortunately I can't write the productization patch right now since I
have a plane to catch in about an hour, but if noone beats me to it I'll
to it Thursday.

	-hpa
