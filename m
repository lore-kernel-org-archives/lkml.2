Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab0JUXFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:05:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51565 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0JUXE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=mNfIPm0c5NlQpWfV7W2Vn8FBxGGV9aXvSvgQsjBnewBgPPZV+eQT8dpEHGubVg85lE
         1JodvbJH9zPbBHuj3AjRfIDbccU0sLJITSuZglV9woILp6p+EaOGpAUNbOx7OYUJ4LPv
         FEKp1eiC6Zy3oO5+bEyhStTvbh+A+Kk3N2iEQ=
MIME-Version: 1.0
In-Reply-To: <20101021155528.b3d6d027.akpm@linux-foundation.org>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
 <20101021150250.f6499506.akpm@linux-foundation.org> <201010211823.38287.vapier@gentoo.org>
 <20101021155528.b3d6d027.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 21 Oct 2010 19:04:36 -0400
X-Google-Sender-Auth: eJzyCei2f2VaRIFXP1c1xkLHT4Q
Message-ID: <AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 18:55, Andrew Morton wrote:
> On Thu, 21 Oct 2010 18:23:37 -0400 Mike Frysinger wrote:
>> On Thursday, October 21, 2010 18:02:50 Andrew Morton wrote:
>> > On Sat, 16 Oct 2010 13:27:15 -0400 Mike Frysinger wrote:
>> > > If the arch doesn't provide atomic64 functionality (there are quite a
>> > > few), then don't bother trying to build this test.
>> >
>> > I don't get it.  If the arch doesn't implement atomic64 then this file
>> > will get zillions of build errors, won't it?
>>
>> ... which is why i added the ifdef protection
>
> So the changelog was poor.  Please write complete changelogs so I need
> to have this sort of conversation less often?

the changelog seems pretty clear to me.  arch doesnt provide atomic64,
so dont build code that uses atomic64.

> Why doesn't this cause lots of you-broke-my-build complaints?  Nobody's
> running allmodonfig?

that's how i noticed.  perhaps the other arches that dont provide
atomic64 arent doing as many build tests as i am.

>> > > diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
>> > > index 250ed11..0ac1a66 100644
>> > > --- a/lib/atomic64_test.c
>> > > +++ b/lib/atomic64_test.c
>> > > @@ -12,6 +12,8 @@
>> > >
>> > >  #include <linux/kernel.h>
>> > >  #include <asm/atomic.h>
>> > >
>> > > +#ifdef ATOMIC64_INIT
>> >
>> > hm, that's a bit lazy.  It should really use a CONFIG_HAVE_ thing.  What
>> > a pita.
>>
>> ATOMIC64_INIT is required for atomic64 headers to provide, and having a
>> Kconfig knob doesnt gain anything else
>
> I know that.  But the standard way for an architecture to indicate to
> the core that it impements a feature is for it to define CONFIG_HAVE_*.
> Picking some related #define which architectures happen to implement
> is atypical and unexpected.
>
> Will it cause problems?  Probably not, unless the arch goes and defines
> ATOMIC64_INIT without actually implementing atomic64.  But it's
> atypical and unexpected and, yes, lazy!

you can say "lazy" all you like.  i dont see the point in going that route.
-mike
