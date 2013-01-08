Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3AHTie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:38:34 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:57269 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab3AHTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130108191600.GA12563@merkur.ravnborg.org>
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
 <20130106093649.GA17429@merkur.ravnborg.org> <CAPQV+nP1UJP4R8AmoUf4bt873Yz_D0ZR2msaCRx5eAc49QFodA@mail.gmail.com>
 <20130108191600.GA12563@merkur.ravnborg.org>
From: Jonathan Kliegman <kliegs@chromium.org>
Date: Tue, 8 Jan 2013 14:38:10 -0500
Message-ID: <CAPQV+nNHPw4r=+2ftqXDgRtFZHZXk3+n_ZCAAGyv9axWDt9KMg@mail.gmail.com>
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches fatal
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 2:16 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Jan 06, 2013 at 03:22:39PM -0500, Jonathan Kliegman wrote:
>> On Sun, Jan 6, 2013 at 4:36 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > Hi Jonathan.
>> >
>> >> The section mismatch warning can be easy to miss during the kernel build
>> >> process.  Allow it to be marked as fatal to be easily caught and prevent
>> >> bugs from slipping in.
>> >>
>> >> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
>> >
>> > Another way to make them much more visible would be to make
>> > the warnings always be verbose.
>>
>> I'd like to keep the option for a hard fail if a mismatch is detected.
>>  This way automated build systems will detect the failed build and can
>> reject a chan
>>
>> > In other words drop support for the "-S" options used below:
>> >>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)
>> >
>> > Previously the dev* stuff caused a lot of warnings, but
>> > since we have HOTPLUG always enabled this is a non-issue.
>> > So I think that this is a good time to enable the verboce
>> > warnings.
>> I can submit a second patch for this if you'd like, but I'm not
>> familiar with all the previous decisions in this area.  If I
>> understand correctly we'll still need the config option as it also
>> changes compiler flags for inlining.
>
> Correct.
> We need one config option that allows us to debug section mismatchs.
> This options adds another gcc option as you also points out.
> And this is the one that already exist.
>
> And then you suggest to add another options which makes section
> mismatch warnings fatal.
> This sounds like a good idea but reverse the logic.
> Something like:
>
>    CONFIG_SECTION_MISMATCH_WARN
>         bool "Section mismatch warnings produced by modpost are non-fatal"
>         default y
>         help
>           bla bla
>
> Because then you do not cause section mismatch to be fatal for allyesconfig and
> allmodconfig builds. We really do not want to go there yet (I think).
> I must admit I do not know how many section mismatch warnigns that are lingering
> for the different architectures.
> If the number is sufficiently low then we could consider go for fatal as default.
>
>
> And it would be good to have first patch that makes section mismatch warnings verbose,
> independent on any config options.
>
> This patch would have to do something like:
> - Makes it possible to set CONFIG_DEBUG_SECTION_MISMATCH using menuconfig (I recall there are
>   a dependency that avoids this today)
> - Drop support for the -S options and drop the bits that set it
> - Drop the reference to CONFIG_DEBUG_SECTION_MISMATCH in modpost error message
>
> I would be happy if you could do this and test it.
Ok - I understand what you mean now.  I'll put this together as a two
patch sequence then and upload it later this week.  Should I start a
new thread with that since its adding a new patch?  Or just respond
here with it?
>
>         Sam
