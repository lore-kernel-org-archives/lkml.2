Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1AFXZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:25:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab1AFXZz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110106225301.GA27358@gondor.apana.org.au>
References: <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
 <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
 <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
 <20110106223042.GA27080@gondor.apana.org.au> <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com>
 <20110106225301.GA27358@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 15:25:32 -0800
Message-ID: <AANLkTi=E3fqTos7A2fJ2PRKT=o5=sgWh+CzMv4G7P4rZ@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 2:53 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> On Thu, Jan 06, 2011 at 02:43:35PM -0800, Linus Torvalds wrote:
>>
>> Can you do the "bypass directly to the TCP stream" with the interface
>> you added? It isn't at all obvious how it would work.
>
> Yes it can.  The interface allows zero-copy in both directions
> using the splice interface.  Here is a sample program demonstrating
> zero-copy in-place encryption.  It doesn't send the result over TCP
> but I'm sure you can imagine what that would look like.

Ok. So can we actually get numbers for this?

Put another way: I really really REALLY don't want to merge new
user-space interfaces that don't actually work in reality. But if this
allows direct encryption to a network interface, and it actually is
able to saturate 10Gb on niagara (unlike a user-mode encryption thing,
I assume, since those things are dog slow), then that would certainly
be a good real-life test.

But I really don't want to merge it unless it has had at least
real-life testing of actually doing better than regular sw user-space
encryption.

I realize that on PC's, it's unlikely to ever help. So I'm not asking
for "show me how this helps on my hardware". But I do want to get some
case on _some_ actual hardware where it works on a real load.

                    Linus
