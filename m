Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab1BDSd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:33:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33622 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BDSd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:33:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NEBB5ZgSygmYOGDHXH4EsonP12ewnvpKxTGgl8lOq1seNXwsKQd20FCmORG745vPQc
         dAY8aOb7QCcCBDwvA7nytGasAQctQB3pGZu7NGWbQcmaPjQTTbx3QV92T/R/1AXTEZ43
         aw99Ie6hndafEzhuEyJRosMllj/oUdUViO9aE=
Message-ID: <4D4C468F.4080105@gmail.com>
Date: Fri, 04 Feb 2011 19:33:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <201101202202.01089.rjw@suse.com> <4D472B9E.5090000@gmail.com> <201101312300.34008.rjw@suse.com>
In-Reply-To: <201101312300.34008.rjw@suse.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 11:00 PM, Rafael J. Wysocki wrote:
> On Monday, January 31, 2011, Jiri Slaby wrote:
>> On 01/20/2011 10:02 PM, Rafael J. Wysocki wrote:
>>> On Thursday, January 20, 2011, Jiri Slaby wrote:
>>>> On 01/06/2011 03:18 PM, Jiri Slaby wrote:
>>>>> On 12/14/2010 11:22 PM, Rafael J. Wysocki wrote:
>>>>>> On Tuesday, December 14, 2010, Jiri Slaby wrote:
>>>>>>> On 12/13/2010 10:10 PM, Rafael J. Wysocki wrote:
>>>>>>>> On Monday, December 13, 2010, Jiri Slaby wrote:
>>>>>>>>> On 12/05/2010 02:08 PM, Rafael J. Wysocki wrote:
>>>>>>>>>> On Sunday, December 05, 2010, Jiri Slaby wrote:
>>>>>>>>>>> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
>>>>>>>>>>>> The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
>>>>>>>>>>>
>>>>>>>>>>> Hi, this kernel regresses with respect to resume. It doesn't wake up,
>>>>>>>>>>> the screen is black with blinking cursor at position [1, 1].
>>>>>>>>>>> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
>>>>>>>>>>> far.
>>>>>>>>>>>
>>>>>>>>>>> I'm using pm-suspend, any ideas what to test before I start to find the
>>>>>>>>>>> reason on my own?
>>>>>>>>>>
>>>>>>>>>> Please try the pm_test tests for core, processors and devices, eg.:
>>>>>>>>>
>>>>>>>>> Hmm, I haven't seen the issues since then. So it had to be some kind of
>>>>>>>>> coincidence -- I see the issue occasionally for some time already. Now
>>>>>>>>> it triggered twice in a row after I updated the kernel.
>>>>>>>>
>>>>>>>> Hmm.  What hardware is that?
>>>>>>>
>>>>>>> What exactly do you want to know about it? It's some specific intel
>>>>>>> desktop machine, 3 years old, 2 intel cores, 6G of mem, 2 sata disks in
>>>>>>> raid, dvb-t usb receiver (af9015), usb keyboard and mouse.
>>>>>>
>>>>>> I'm seeing pretty much the same symptoms on quite different hardware, except
>>>>>> for one thing: USB keyboard and mouse.
>>>>>>
>>>>>> Have you checked if writing 0 to /sys/power/pm_async helps?
>>>>>
>>>>> It's very hard to reproduce (it happens once a week or two), so I can't
>>>>> say yet. As it happened yesterday again, going to test it from now on.
>>>>
>>>> Ok, I haven't seen the issue with 0 in /sys/power/pm_async for two weeks
>>>> now (I added it to boot.local). I would say it's related to that...
>>>
>>> In that case the next step would be to build the kernel with
>>> CONFIG_PM_ADVANCED_DEBUG set and try to switch the async flag for individual
>>> devices (it is located is /sys/devices/.../power/ for each device).
>>>
>>> For example, I wonder if it is sufficient to unset it for all USB devices.
>>
>> It seems to suffice... No hangs still. Should I enable pm_async back
>> again to confirm the issue is still present?
> 
> Yes, please, it would be good to know for sure.

Ok, confirmed right now :).

I disabled pm_async for USB again. What do you suggest next?

thanks,
-- 
js
