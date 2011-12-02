Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab1LBS2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:28:53 -0500
Received: from ffm.saftware.de ([83.141.3.46]:56258 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1LBS2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:28:52 -0500
Message-ID: <4ED918DD.7050103@linuxtv.org>
Date: Fri, 02 Dec 2011 19:28:45 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <201112021949.19395.remi@remlab.net> <4ED91608.5020503@linuxtv.org>
In-Reply-To: <4ED91608.5020503@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.2011 19:16, Andreas Oberritter wrote:
> On 02.12.2011 18:49, Rémi Denis-Courmont wrote:
>> Le jeudi 1 décembre 2011 21:59:56 HoP, vous avez écrit :
>>>> Kernel code is GPLv2. You can use its code on a GPLv2 licensed library.
>>>
>>> I see. So if you think it is nice to get dvb-core, make a wrapper around
>>> to get it usable in userspace and maintain totally same functionality
>>> by myself then I say it is no go. If it looks for you like good idea
>>> I must disagree. Code duplication?
>>
>> Sure, some core code would be duplicated. That is not a big deal.
>>
>> This proposal however has three big advantages:
>> - Proprietary drivers are not enabled as the library would be GPL.
>> - The virtual DVB device runs in the same process as the DVB application, 
>> which saves context switching and memory copying.
>> - It would be your project. You do not need to agree with Mauro ;-)
>>
>>> Two maintaners? That is crazy idea man.
>>
>> Someone would have to maintain the device driver anyway. I don't see much of a 
>> difference on maintainance side.
>>
>>>> And I can't see any advantage on yours ;) Putting something that belongs
>>>> to userspace into kernelspace just because it is easier to re-use the
>>>> existing code inside the kernel is not a good argument.
>>>
>>> It is only your POV that it should be in userspace.Also, LGPL drivers 
>>
>> Except for backward compatiblity, this would actually belong in userspace. It 
>> would be more efficient and easier to maintain as a userspace library than as 
>> a kernel driver.
> 
> Maintaining the kernel module would be rather easy, because new
> properties added to dvb_frontend would be handled transparently. The
> implementation is quite simple. In contrast, implementing and then
> maintaining all the users of a newly written userspace library would be
> a nightmare in comparison.
> 
>> If you need backward compatibility, I am still inclined to believe that you 
>> could write a CUSE frontend, so it does involve some extra work and looses the 
>> performance benefit.

One more note: CUSE would conflict with dvb-core the same way Mauro's
sockets would do.

> How would all this allow to use e.g. dvbsnoop or w_scan on a remote
> tuner? Do you propose to add a dependency to this proposed library to
> every application?
> 
> Furthermore, a GPLv2 library would artificially restrict its users, e.g.
> you wouldn't be allowed to use it with gstreamer or just with anything
> that isn't GPLv2, not even v3.
> 
> Regards,
> Andreas

