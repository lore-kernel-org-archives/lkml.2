Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524Ab0HFB0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:26:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57196 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232Ab0HFB0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I3+PUvN6Qwu5RV+LqRBulT7FKLv8zLAJZLPgORXXaJE2+HfPYaoN+gbnA776XxmiDb
         koi3g7Y6uCWG4kQEtcuVtGY0+JaPvA/NCwyEcKk6I5mNPtqEgCdqbwwn0YZEuNx6QjKY
         NqD7nif/6IJjRGWBwnsFKwhLVhbLwsAbfUFd8=
Message-ID: <4C5B64EA.2000804@gmail.com>
Date: Thu, 05 Aug 2010 18:27:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Marek <mmarek@suse.cz>, JBeulich@novell.com, aris@redhat.com,
        catalin.marinas@arm.com, jacmet@sunsite.dk, lizf@cn.fujitsu.com,
        sam@ravnborg.org, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com>
In-Reply-To: <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 04:33 PM, Linus Torvalds wrote:
>   On Wed, Aug 4, 2010 at 5:51 AM, Michal Marek<mmarek@suse.cz>  wrote:
>>
>> this is the kconfig part of kbuild. We have four new *config targets:
>> * oldnoconfig: set all new options to 'n'
>> * listnewconfig: list all unset config options
>> * alldefconfig: set all options to their defaults specified in Kconfig
>>   files
>> * savedefconfig: write a defconfig file with only the differences from
>>   an alldefconfig (aka minimal defconfig)
>>
>> Kconfig also warns when a select statement selects a symbol with unmet
>> dependencies (which typically results in a broken config). Li Zefan did
>> quite some usability fixes to the visual config interfaces.
>
> Hmm. This seems to make "make oldconfig" a _lot_ more verbose than it
> used to be. In a very annoying way.
>
> I'm used to this (v2.6.35 "make oldconfig" with no changes):
>
>     [torvalds@i5 linux]$ make oldconfig
>     scripts/kconfig/conf -o arch/x86/Kconfig
>     #
>     # configuration written to .config
>     #
>     [torvalds@i5 linux]$
>
> but now it prints _everything_. The old "oldconfig" only printed
> things out when there was something to be asked about.
>
> This is a regression.
>
>                Linus
>

With what I submitted I did not test make oldconfig, only make 
menuconfig due to gcc 4.6.0 giving me a slew of warnings.
 From looking at make oldconfig I do see a more detailed explanation of 
what each option is(last I remember it was more of a line with y/n)but 
then again you could be seeing something completly different.

keep in mind not sure if this is with kconfig merge or not due to me 
seeing make oldconfig react the same way with 2.6.35-rc6-00191-ga2dccdb
and the current(pulled a few minuetes ago)
but look kind of differently with 2.6.34(but could be wrong due to not 
using make oldconfig that much).
Now if this is with what I submitted then I'll have a look at it and see 
if I can get this fixed.

Justin P. Mattock

