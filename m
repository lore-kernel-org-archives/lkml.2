Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab0HFTWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:22:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53530 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0HFTWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I/6Wu+7o5A/gX8FGPsTANqhrDDVjZ4vM3xSGze9S9lVhr8B0Y6yeqQS/l/yao2R1bm
         EAh4OpOEMkxHzKh3Xssqmy8o+B14ghHccxLfJST+0z8pwpIu1gOM+SvNpRjKu30tOQXT
         YR1/icgIiwsZ9qaVgHPOiAQThDbDrGFV2D9BU=
MIME-Version: 1.0
In-Reply-To: <20100806135429.GB25864@merkur.ravnborg.org>
References: <AANLkTimyDwWtLbc682rW-QORjU0+r+txZO-iKAini1H1@mail.gmail.com>
	<1280838492-9942-1-git-send-email-nir.tzachar@gmail.com>
	<20100805100408.5b724047.randy.dunlap@oracle.com>
	<AANLkTi=9hBYy4k=tJBo38O98z_O646ZpStqNdEYWP3MO@mail.gmail.com>
	<20100806135429.GB25864@merkur.ravnborg.org>
Date: Fri, 6 Aug 2010 22:22:10 +0300
Message-ID: <AANLkTinz4sdP5vENRqn9MgmfovWKK0vBj5bHNzP4ABjx@mail.gmail.com>
Subject: Re: [PATCH] nconfig: add search support
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 4:54 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >>
>> >> Searching: pressing '/' triggers search mode. nconfig performs a
>> >>            regular string compare, case insensitive, starting at
>> >
>> > I would say: simple string compare
>> > "regular" has no meaning (at least for me) there.
>
> pressing '/' triggers interactive search mode. nconfig search for the
> string in the menu prompts (no regex support).
>
> [Just a suggestion for a bt different wording]
>
>> > Maybe I should just stick to config symbol searches.  I don't think it's all
>> > that likely that people will know how each menu line text begins.
>> >
>> >
>>
>> We can replace strcasecmp with strcasestr. I agree it would be more useful.
>
> This is better.
>
>>
>> > As for the search UI, I'd rather that it be presented like the symbol search,
>> > in a box, instead of just a single line at the top of the screen.
>>
>> But then it is not interactive. I was aiming for something similar to
>> vim's search, where the search is matched as you type and the only
>> free terminal real-estate to display the match string was at the top
>> of the screen. I think such a minimal design is better than a
>> cumbersome text box which displays the search results afterwards (as
>> is symbol search), as the search is only intended for the currently
>> displayed menu and the user would usually just want to save the extra
>> typing of navigating to a specific menu item.
>
> It was introduced to replace the "hotkey" support, and as such is useful.
> If we want to search for content of all prompts then we should extend
> the symbols search to do so.
> Maybe we should just let it search for both symbols _and_ propmts.

There is a different alternative which slipped my mind, which can be
useful for Randy's use case: just use the single menu mode of nconfig
and then the search feature will give you the behavior you desire
(i.e., jumping to the globally matching prompt).

> If one search for HOTPLUG_CPU there is no hits in any propmts anyway.
> And if one search for "Pentium" there is no config symbol hits.

If such a search cannot return the menu context of the matching
symbol, there is no way for nconfig to jump to the matching menu. But
a different approach may be to add the symbol search to nconfig's
search, such that instead of just matching the prompt, nconfig will
also match the symbol.

Cheers,
Nir.

>        Sam
>
