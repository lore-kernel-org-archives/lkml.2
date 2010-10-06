Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0JFAwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:52:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64418 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab0JFAwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=A3wOMJIcS3324TQdPdLVgxdnlG3+wi90TV4X0eLjeh+WL5+ZH1rwpObrrBeV9/xr3F
         ZgXpm7LDvxOohtreRVE1LEOXeRYBXgHlQbe/XYcUQzAs7Ym+O7+lLyp2QKLPkXSH4fQJ
         tISGS+HZxxs5AXyTOx/2jXBEPvQ53h2fOwwYI=
MIME-Version: 1.0
In-Reply-To: <20101005235355.GB18586@haskell.muteddisk.com>
References: <1285534847-31463-1-git-send-email-mfm@muteddisk.com>
	<20101005142906.GA20059@merkur.ravnborg.org>
	<20101005192435.GA17798@haskell.muteddisk.com>
	<AANLkTik4Ezpj939za2PMWOqOxjXnbdXjvtbXR6Tau2zr@mail.gmail.com>
	<20101005235355.GB18586@haskell.muteddisk.com>
Date: Tue, 5 Oct 2010 20:52:20 -0400
Message-ID: <AANLkTin+vdjH_JaWqc-iWHQ=92kEg9Nc2T9wruTOFpYZ@mail.gmail.com>
Subject: Re: [RFC PATCH] media: consolidation of -I flags
From: T Dent <tdent48227@gmail.com>
To: T Dent <tdent48227@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/10, matt mooney <mfm@muteddisk.com> wrote:
> On 18:27 Tue 05 Oct     , T Dent wrote:
>> On 10/5/10, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > On Sun, Sep 26, 2010 at 02:00:47PM -0700, matt mooney wrote:
>> >> I have been doing cleanup of makefiles, namely replacing the older
>> >> style
>> >> compilation flag variables with the newer style. While doing this, I
>> >> noticed that the majority of drivers in the media subsystem seem to
>> >> rely
>> >> on a few core header files:
>> >>
>> >> 	-Idrivers/media/video
>> >> 	-Idrivers/media/common/tuners
>> >> 	-Idrivers/media/dvb/dvb-core
>> >> 	-Idrivers/media/dvb/frontends
>> >>
>> >> This patch removes them from the individual makefiles and puts them in
>> >> the main makefile under media.
>> > Using subdir-ccflags-y has one drawback you need to be aware of.
>> > The variable is _not_ picked up if you build individual drivers like
>> > this:
>> >
>> >
>> >      make drivers/media/dvb/b2c2/
>> >
>> > So with this patch applied it is no longer possible to do so.
>> > It is better to accept the duplication rather than breaking
>> > the build of individual drivers.
>> >
>> >>
>> >> If neither idea is considered beneficial, I will go ahead and replace
>> >> the older variables with the newer ones as is.
>> >
>> > This is the right approach.
>> >
>> > You could consider to do a more general cleanup:
>> > 1) replace EXTRA_CFLAGS with ccflags-y (the one you suggest)
>> > 2) replace use of <module>-objs with <module>-y
>> > 3) break continued lines into several assignments
>>
>> I have a question when you say this do you mean change something like
>> this:
>>
>> r8187se-objs :=
>>
>> to
>>
>> r8187se-y :=
>
> Yes, that is what is meant, but remember to change conditional inclusions to
> the
> kbuild idiom.

Okay, I get start on it right away.
>
>> If so, I could start working on that in the staging directory.
>
> That's cool; the staging makefiles need extra attention though, so you
> really
> need to go through and make sure you understand what is and isn't needed.
> And
> check to see what drivers are on their way out so that you don't waste your
> time.
>
> Now, I do have some of these queued up for other parts of the kernel, so
> please
> let me know before you start sending in patches for other parts that I have
> already worked on.

I message you if haven't sent the patches in, yet to see what you did
or are doing.
>
> Thanks,
> mfm
>
>> >    People very often uses '\' to break long lines, where a
>> >    simple += would be much more readable.
>> >    But this topic may be personal - I never uses "\" in my .c code
>> > unless in
>> > macros,
>> >    and I have applied the same rule for Makefiles.
>> >    An ugly example is drivers/media/Makefile
>> > 4) In general use ":=" instead of "=".
>> >    Add using "+=" as first assignment is OK - but it just looks plain
>> > wrong
>> > 5) some files has a mixture of spaces/tabs (are red in my vim)
>> >    dvb-core/Makefile is one such example
>> > 6) remove useless stuff
>> >    siano/Makefile has some strange assignments to EXTRA_CFLAGS
>> > 7) Likely a few more items to look after...
>> >
>> > This is more work - but then you finish a Makefile rather than doing a
>> > simple
>> > conversion.
>> >
>> > 	Sam
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> Thanks,
>>
>> Tracey D
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
Thanks,

Tracey D
