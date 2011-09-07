Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab1IGS0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1IGS0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:26:40 -0400
Message-ID: <4E67B75B.8010500@redhat.com>
Date: Wed, 07 Sep 2011 14:26:35 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>  <1315417137-12093-1-git-send-email-jarod@redhat.com> <1315419179.3576.6.camel@lappy>
In-Reply-To: <1315419179.3576.6.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On Wed, 2011-09-07 at 13:38 -0400, Jarod Wilson wrote:
>> Certain security-related certifications and their respective review
>> bodies have said that they find use of /dev/urandom for certain
>> functions, such as setting up ssh connections, is acceptable, but if and
>> only if /dev/urandom can block after a certain threshold of bytes have
>> been read from it with the entropy pool exhausted. Initially, we were
>> investigating increasing entropy pool contributions, so that we could
>> simply use /dev/random, but since that hasn't (yet) panned out, and
>> upwards of five minutes to establsh an ssh connection using an
>> entropy-starved /dev/random is unacceptable, we started looking at the
>> blocking urandom approach.
>
> Can't you accomplish this in userspace by trying to read as much as you
> can out of /dev/random without blocking, then reading out
> of /dev/urandom the minimum between allowed threshold and remaining
> bytes, and then blocking on /dev/random?
>
> For example, lets say you need 100 bytes of randomness, and your
> threshold is 30 bytes. You try reading out of /dev/random and get 50
> bytes, at that point you'll read another 30 (=threshold) bytes
> out /dev/urandom and then you'll need to block on /dev/random until you
> get the remaining 20 bytes.

We're looking for a generic solution here that doesn't require 
re-educating every single piece of userspace. And anything done in 
userspace is going to be full of possible holes -- there needs to be 
something in place that actually *enforces* the policy, and centralized 
accounting/tracking, lest you wind up with multiple processes racing to 
grab the entropy.

-- 
Jarod Wilson
jarod@redhat.com


