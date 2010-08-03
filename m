Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0HCEhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:37:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42360 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0HCEhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KIYrpo4K+IWNHMG8eylggKRTXjZj6NTitZYVW1UY+2LJSdUp3PfAXH9GCv/ChQhQcW
         lHQ/4VwcCQl+vRF1N1sVVzy/rhSNIEJb3AzjeWZ+vbuKDMHiXymo3/DwWpsN+NoUewr1
         QrLjVktRHAE7Xb4rmwwh2NDMCsyNQ6FWLOa9w=
MIME-Version: 1.0
In-Reply-To: <20100802093257.41a5debe.rdunlap@xenotime.net>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
	<1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
	<20100802093257.41a5debe.rdunlap@xenotime.net>
Date: Tue, 3 Aug 2010 07:37:44 +0300
Message-ID: <AANLkTik4PmwBrP9DEoOUad6=-cf8tC=vMU7AmoAMBDzy@mail.gmail.com>
Subject: Re: [PATCH] nconfig: add search support
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, trapdoor6@gmail.com, justinmattock@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 7:32 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sun,  1 Aug 2010 10:20:33 +0300 nir.tzachar@gmail.com wrote:
>
>> From: Nir Tzachar <nir.tzachar@gmail.com>
>>
>> Remove the old hotkeys feature, and replace by a regular string search.
>> From nconfig help:
>>
>> Pressing '/' triggers search mode. nconfig does regular string match, case
>> insensitive, starting at the begining of each menu line.
>
> What is a "regular string match"?
> That's not the same as a regular expression match, right?
>
> Maybe it's a "simple string match"?

strcasecmp. I've considered using regex or fnmatch, but it seemed an overkill.

>> Pressing Enter highlights the next match, Backspace removes one character from
>> the match string. Pressing either '/' again or ESC exits search mode.
>>
>> Rebind the '/' key (which allowed to search for symbols) to F8
>>
>> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
>> ---
>>  scripts/kconfig/nconf.c |  261 ++++++++++++++++++++++-------------------------
>>  scripts/kconfig/nconf.h |    3 +-
>>  2 files changed, 125 insertions(+), 139 deletions(-)
>>
>> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
>> index 762caf8..2a7cb37 100644
>> --- a/scripts/kconfig/nconf.c
>> +++ b/scripts/kconfig/nconf.c
>> @@ -41,9 +41,12 @@ static const char nconf_readme[] = N_(
>>  "   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
>>  "   Submenus are designated by \"--->\".\n"
>>  "\n"
>> -"   Shortcut: Press the option's highlighted letter (hotkey).\n"
>> -"             Pressing a hotkey more than once will sequence\n"
>> -"             through all visible items which use that hotkey.\n"
>> +"   Searching: pressing '/' triggers search mode. nconfig does a\n"
>> +"              regular string match, case insensitive, starting at\n"
>> +"              the begining of each menu line.\n"
>> +"              Pressing Enter highlights the next match, Backspace\n"
>> +"              removes one character from the match string.\n"
>> +"              Pressing either '/' again or ESC exits search mode.\n"
>>  "\n"
>>  "   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
>>  "   unseen options into view.\n"
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
