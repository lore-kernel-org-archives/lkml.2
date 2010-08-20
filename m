Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab0HTGkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:40:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0HTGj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=I+3XKJmIq0zFRFbK6zys9uQ0HYJ7u9lMuWJElH2gPod3J3y3Lq7k1OvrzLiEwT8HzY
         rlRTcRNLCq32moBBCdgnpxkRzF5d3S11Qb9mYuZQ2hMoK5bduTJIGUPN+15GWSKczcsB
         QNqhRD52quccPNi4jqMedZ1MreLTQK9UHx0Yg=
Message-ID: <4C6E233A.5000209@gmail.com>
Date: Fri, 20 Aug 2010 08:39:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-acpi@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
References: <4C613619.30309@gmail.com> <4C619CF0.30609@gmail.com> <20100820063107.GB1607@ucw.cz>
In-Reply-To: <20100820063107.GB1607@ucw.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 08:31 AM, Pavel Machek wrote:
> On Tue 2010-08-10 20:39:44, Jiri Slaby wrote:
>> On 08/10/2010 01:20 PM, Jiri Slaby wrote:
>>> Hi,
>>>
>>> till I was running on 2.6.34-rc5-mm1 (mmotm) and earlier everything was
>>> fine. Now, I'm running 2.6.35-rc6-mm1 (.35-rc5-mm1 was the same) and
>>> sometimes when the computer (desktop) returns from S3, the CPU fan is
>>> running at full speed making a big noise.
>>
>> Just to add, full power cycle is needed to get rid of that. Warm reboot
>> is not enough.
> 
> Seems like bios problem... Update bios?

I don't think so, it had been working for more than 2 years before this
issue appeared.

>>> I don't know how to debug that. Bisection is out of question -- it
>>> happens once in 10 or 20 cases. There are no fan entries in /sys.
> 
> Well, doing 20 suspends in a row from a script should not be too bad.

20 is just a guess. I haven't seen it for pretty few days until the day
before yesterday. And it looks like CPU1 is brought up a half way. When
the fan was at full speed I tried:
echo 0 > /sys/devices/system/cpu/cpu1/online
and whole system freezed. Otherwise this commands succeeds.

I'll load a crash kernel prior turning the CPU off next time.

thanks,
-- 
js
