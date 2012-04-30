Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2D3LJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab2D3LJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:09:33 -0400
Message-ID: <4F9E72E0.300@redhat.com>
Date: Mon, 30 Apr 2012 08:09:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Joe Perches <joe@perches.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <1335535895.25521.7.camel@joe2Laptop> <4F9AC44A.5000509@redhat.com> <20120428085223.GB26065@aftab.osrc.amd.com> <4F9D4F6E.4070106@redhat.com> <4F9D5A2E.2030506@redhat.com> <4F9D6A39.6040209@redhat.com> <1335717794.12022.19.camel@joe2Laptop> <4F9D7CB8.4000903@redhat.com> <20120430074717.GB8182@aftab.osrc.amd.com>
In-Reply-To: <20120430074717.GB8182@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 04:47, Borislav Petkov escreveu:
> On Sun, Apr 29, 2012 at 02:39:04PM -0300, Mauro Carvalho Chehab wrote:
>> Em 29-04-2012 13:43, Joe Perches escreveu:
>>> On Sun, 2012-04-29 at 13:20 -0300, Mauro Carvalho Chehab wrote:
>>>> The script below is even better. After that, only 113 occurrences of __func__
>>>> is now found at drivers/edac, and some of them are not related to debugf[1-9],
>>>> so they shouldn't be cover on a patch like that.
>>>> I'll do some manual cleanup on it.
>>>
>>> Hi Mauro.
>>>
>>> Another thing you could do would be to
>>> separate the level from the multiple macros,
>>> use a single macro, and convert the uses.
>>>
>>> #define debugf(level, fmt, ...)
>>> and change the uses to
>>> debugf([0-n], "some format", args...)
>>>
>>> I believe that's the more predominate
>>> kernel style for debugging macros with
>>> a tested level or mask.
>>
>> Agreed.
>>
>>> Perhaps also add !CONFIG_EDAC_DEBUG
>>> format/args checking to the debug statements.
>>
>> Most/all debug-only stuff are already checking for CONFIG_EDAC_DEBUG.
>> There are a few static debug-only data/functions that aren't testing for
>> it, but the compiler should remove the dead code anyway, so this shouldn't
>> cause any harm.
>>
>>> Lastly, indenting the messages 2 tabs isn't
>>> really useful, one or two spaces is probably
>>> enough.
>>
>> agreed.
>>
>>>
>>> I did this a bit ago so it may not apply
>>> after your changes:
>>
>> Believe or not, it applied without troubles ;)
>>
>> I've added at the end of my experimental series, at:
>>
>>
>> git://git.infradead.org/users/mchehab/edac.git experimental
>>
>> be careful if you use this branch, as I'm rebasing it every time I need
>> to change something on this series.
>>
>> I'm keeping a non-rebased version, with one branch per review, at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git
>>
>> The current review is at hw_events_v17. Patches were already pushed there.
>> they should be there after the usual kernel.org master/mirror replication
>> delay.
> 
> Now wait a minute,
> 
> you guys are so trigger-happy to apply humongous, cleanup patches but
> let me ask this: can anyone of you really test those changes with each
> driver? Do you have all the hardware that those patches touch?

Well, then why you've touched that in the first place, without even looking
what would be affected at the EDAC core and at the drivers? Didn't you tested
it on all hardware that your patch affected?

Now that your patch got applied, reverting it is not a solution, as newer
stuff now assumes that __func__ will be at the debug messages. So, reverting
it will cause regressions.

> I know, I know, it builds fine and it looks correct but subtle bugs tend
> to sneak in in exactly such situations.

This patch touches only on debug code that aren't even enabled on production
kernels. Assuming that a sneaky bug were introduced, this won't cause much
hurt, and any developer inspecting those debug messages will be able to discover
and fix what happened there.

Regards,
Mauro
