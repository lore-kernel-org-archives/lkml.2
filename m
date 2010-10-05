Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0JEW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:27:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54415 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0JEW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=VuGT9kyghJoc3BDY1p+W1lFmCaDrd08laix+3Oc+vzkMVMQbcW8edAe0BwO1isLzJL
         2xbOtvhv9kR6rZiVPA2H0ibHb+Vks8jNKdHE6T5dEqSjhBHnQ3utnjMXIhsWRI7qKtlV
         Cjy60Ck71+Yav97m8rYb6k5wu0xjdl04yvAwU=
MIME-Version: 1.0
In-Reply-To: <20101005192435.GA17798@haskell.muteddisk.com>
References: <1285534847-31463-1-git-send-email-mfm@muteddisk.com>
	<20101005142906.GA20059@merkur.ravnborg.org>
	<20101005192435.GA17798@haskell.muteddisk.com>
Date: Tue, 5 Oct 2010 18:27:40 -0400
Message-ID: <AANLkTik4Ezpj939za2PMWOqOxjXnbdXjvtbXR6Tau2zr@mail.gmail.com>
Subject: Re: [RFC PATCH] media: consolidation of -I flags
From: T Dent <tdent48227@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/10, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Sep 26, 2010 at 02:00:47PM -0700, matt mooney wrote:
>> I have been doing cleanup of makefiles, namely replacing the older style
>> compilation flag variables with the newer style. While doing this, I
>> noticed that the majority of drivers in the media subsystem seem to rely
>> on a few core header files:
>>
>> 	-Idrivers/media/video
>> 	-Idrivers/media/common/tuners
>> 	-Idrivers/media/dvb/dvb-core
>> 	-Idrivers/media/dvb/frontends
>>
>> This patch removes them from the individual makefiles and puts them in
>> the main makefile under media.
> Using subdir-ccflags-y has one drawback you need to be aware of.
> The variable is _not_ picked up if you build individual drivers like
> this:
>
>
>      make drivers/media/dvb/b2c2/
>
> So with this patch applied it is no longer possible to do so.
> It is better to accept the duplication rather than breaking
> the build of individual drivers.
>
>>
>> If neither idea is considered beneficial, I will go ahead and replace
>> the older variables with the newer ones as is.
>
> This is the right approach.
>
> You could consider to do a more general cleanup:
> 1) replace EXTRA_CFLAGS with ccflags-y (the one you suggest)
> 2) replace use of <module>-objs with <module>-y
> 3) break continued lines into several assignments

I have a question when you say this do you mean change something like this:

r8187se-objs :=

to

r8187se-y :=

If so, I could start working on that in the staging directory.

>    People very often uses '\' to break long lines, where a
>    simple += would be much more readable.
>    But this topic may be personal - I never uses "\" in my .c code unless in
> macros,
>    and I have applied the same rule for Makefiles.
>    An ugly example is drivers/media/Makefile
> 4) In general use ":=" instead of "=".
>    Add using "+=" as first assignment is OK - but it just looks plain wrong
> 5) some files has a mixture of spaces/tabs (are red in my vim)
>    dvb-core/Makefile is one such example
> 6) remove useless stuff
>    siano/Makefile has some strange assignments to EXTRA_CFLAGS
> 7) Likely a few more items to look after...
>
> This is more work - but then you finish a Makefile rather than doing a
> simple
> conversion.
>
> 	Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks,

Tracey D
