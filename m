Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0C3GtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:49:18 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:44333 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0C3GtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m+PxI5UkOWmyI5kwFLS32uIjWQYpFJDNZiyFeJum3s72rDHTrspapuP7Lw/9uxk0+u
         ZvVTH6j8mS93SU6xU3TnRtMqPFft43SRKyL2ygx/uNoQYzInuHFlVbqBI+FUQ/CZBwpt
         b/VcqiLdHKbGzVrv6gAd4U2e9uQjaonaJmCd8=
MIME-Version: 1.0
In-Reply-To: <1269931411.5480.152.camel@thor.local>
References: <alpine.DEB.2.00.1003300530150.5127@skynet.skynet.ie>
	 <1269931411.5480.152.camel@thor.local>
Date: Tue, 30 Mar 2010 16:49:16 +1000
Message-ID: <21d7e9971003292349v36fc29f3i55d79ecc197df728@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Jerome Glisse <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Michel Dänzer <michel@daenzer.net>:
> On Tue, 2010-03-30 at 05:34 +0100, Dave Airlie wrote:
>>
>> Original pull req below + reverts the fallback placement change which had
>> a side effect of causing more lockups on some AGP systems (this is a bug in
>> the AGP drivers that needs to be tracked down), [...]
>
> While I was able to work around the lockups by making the AGP driver
> never unbind a GTT entry, I think it's rather a radeon issue - how is
> the AGP driver supposed to know when it's safe to unbind an entry?

This issue has been a problem with AGP before, the Intel AGP docs claim
you should always use scratch pages on AGP, and never complete remove
bound entries. I've no idea why this is, as you'd expect AGP cards to
only generate
cycles to entries they've been asked to. There may be some memory controller
prefetching going on that could lead to prefetching into an unbound AGP page
and the resulting machine check that may cause I suppose.

We need to track this separately anyways and fix it for 2.6.35 hopefully, at
least we have a patch that can handle it.

> That change had lots of other issues anyway, thanks for reverting it.
>
>
>> [...] and I've merged Jerome's GPU recovery code, as I'd much rather
>> users had some of hope of recovering from their GPU locking up than a
>> dead box. It seems to work for quite a lot of people that have tested
>> it, and it won't make a GPU lockup problem worse.
>
> Unfortunately, that's not true in all cases. The change itself mentions
> that the new reset code is unreliable for R3xx generation GPUs, and
> indeed with my RV350 it now turns my box into a brick immediately on a
> GPU lockup most of the time whereas previously it was usually able to
> recover at least in some cases, e.g. falling back to PCI mode after
> trying to use a non-working AGP transfer mode.
>

Okay so it makes it worse, hopefully Jerome can track it down, or
else we can lock down the gpu reset to only trying on the r600s where
it definitely makes life a lot better for everyone.

Dave.
