Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0FIJHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:07:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47297 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0FIJHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pqYNBzLZd5YH8wLAimaN295f9BX8oJpExaSn8GUR1wBVZUInDYwdSUchbr9D1v2GPC
         heEKyuRWLa0SXz4rAnt803ZSh4qdSNXf5+q/WqZOWk03n26zloNswWcJNgyr0DvxZQn2
         lRmYDLF9pNE078kNniXz1k4zgHdB2XIjP/ZhM=
Message-ID: <4C0F59C8.8020704@tuffmail.co.uk>
Date: Wed, 09 Jun 2010 10:07:20 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: BUG when battery is removed before resuming from
 hibernation
References: <4C0E40E1.2080108@tuffmail.co.uk> <201006082252.49452.rjw@sisk.pl>
In-Reply-To: <201006082252.49452.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 08 June 2010, Alan Jenkins wrote:
>   
>> I found this bug 2.6.34 on my Asus EeePC 701 (x86_32 arch).  It didn't 
>> happen to me before, when I was running nearly-2.6.33 or 2.6.32-release.
>>
>> I used git-bisect, but unfortunately the result isn't very helpful.  My 
>> next step will be to try to narrowing down the culprits by disabling 
>> individual CONFIG options.  Here are my results so far, in case anyone 
>> is interested.
>>
>>
>> == Steps to reproduce ==
>>
>> I) Boot off mains power, with battery removed.  Login to KDE4 session, 
>> with Konsole as the only running application.
>> II) Run "sudo pm-hibernate"
>>
>> 1. When the system switches to text mode (a.k.a the console), 
>> immediately insert the battery.
>> 2. Once the system has fully hibernated, remove the battery.
>> 3. Press the power button to resume.  The backtrace below is generated 
>> during resume.
>>     
>
> You're not supposed to be doing that.
>
> Rafael
>   

I take it you mean "don't plug devices in during hibernation; you'll run 
out of memory, Bad Things will happen, and you can expect resume to 
fail".  Pity.  It wasn't an artificial test case, just an unusual usage 
pattern of mine[1].

I guess it wouldn't be guaranteed safe even if I was plugging the device 
in first.  The battery connection could take a few seconds to stabilize, 
and there's software equivalents in things like the usb-storage delay.

I can't complain about safety margins; other people might want to do 
similar things with an entire docking station...

Any chance of a big screaming warning?  IIRC there's one global flag to 
fail userspace call-outs while userspace is frozen.  Would it be 
acceptable to document this in code & behaviour by aborting the 
hibernation on hot-plug?  (hot-*un*plug would presumably be allowed).

Alan


[1] I do this for conservation.  I'm told batteries last longer if I 
don't use them & let them get warm.  I put the battery in for 
hibernation so I can remove mains power without waiting.  I start 
hibernation first, because in practice you have to have the screen 
closed in order to plug or unplug the battery.
