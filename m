Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0G2Tu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:50:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55365 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab0G2Tuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xEH0+ebymNX133WirjmYOXD/sBlp6ywRO8EAKKuQYk1tA8lM8crDevU2IRPL4/NPwX
         bjDLRR2Ysl/p0RCsSTGJ5JRTefDkuQweLkhMxDOWXOMWpNhSvVH1AfZL4kQ4pzzCH/ki
         fuKuq6I7o8Q64GIlv3EgQJR7/puAH/qFSZKTA=
MIME-Version: 1.0
In-Reply-To: <20100729071914.bf615447.rdunlap@xenotime.net>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com>
	<20100727165549.GC26649@merkur.ravnborg.org>
	<AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com>
	<4C500E41.40708@suse.cz>
	<AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com>
	<4C504FBB.3020600@suse.cz>
	<20100728185505.GF29266@merkur.ravnborg.org>
	<AANLkTikpm8St4egQ7PpExzKkSTff5VZN-dKjAAA0nwoN@mail.gmail.com>
	<AANLkTimhKT=mmL7Q5D1z2mzu7wt25_NzA328Tp3T8y0v@mail.gmail.com>
	<4C51362E.5010009@suse.cz>
	<AANLkTi=7ioo3HPVhWYu5OmyoOcaedzyQQ9z=5w2MrTt4@mail.gmail.com>
	<20100729071914.bf615447.rdunlap@xenotime.net>
Date: Thu, 29 Jul 2010 22:50:50 +0300
Message-ID: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>, trapdoor6@gmail.com,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 5:19 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Thu, 29 Jul 2010 13:33:49 +0300 Nir Tzachar wrote:
>
>> On Thu, Jul 29, 2010 at 11:05 AM, Michal Marek <mmarek@suse.cz> wrote:
>> > On 29.7.2010 08:20, trapDoor wrote:
>> >> On Thu, Jul 29, 2010 at 6:04 AM, Nir Tzachar <nir.tzachar@gmail.com> wrote:
>> >>> On Wed, Jul 28, 2010 at 9:55 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >>>> The capitilazing is the main reason why I have
>> >>>> not recommended nconfig to be default.
>> >>>>
>> >>>> And I doubt the shortcut letters are used that often.
>> >>>> One idea could be to drop the shortcut for the individual menus.
>> >>>
>> >>> I almost never use them and removing them will have the benefit of
>> >>> cleaning the code.
>> >>
>> >> Neither do I. And I don't know anyone who would find them very useful.
>> >
>> > I actually do. Unlike menuconfig, nconfig will jump to a menu item even
>> > if it is not currently visible in the screen. Useful if you know the
>> > option name but don't want to scroll down and look for it. But I would
>> > accept a patch to remove the shortcut if there is no better way of
>> > marking the shortcuts than the capital letters.
>> >
>> > Michal
>> >
>>
>> There is a middle ground here: keep the shortcuts, but give no visual
>> indication (either capitalization or coloring).
>
> How do you tell libmenue what the shortcut character is?
> Is that a different attribute/field/specifier?

You can feed ascii chars to the menu_driver, which then employs a
pattern match to jump to a matched item. However, I have not used this
logic as I needed to implement the m,y,n etc. shortcuts.

Coming to think about it, it might be possible to use the built-in
pattern matching of libmenu by first pressing the '/' key, and then
feeding consecutive key presses to the menu_driver routine. I'll try
to come up with a patch.

> If so, how about just adding the shortcut key in parentheses [or square
> brackets] after its word or phrase?  E.g.:
>
>        Hardware Error Device [A]
>

This might be a problem, as there are options which are longer than
the width of a regular terminal..


Cheers.
