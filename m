Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1JTBca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 21:32:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1JTBc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 21:32:29 -0400
Message-ID: <4E9F7A25.1060001@canonical.com>
Date: Thu, 20 Oct 2011 09:32:21 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Sam Tygier <samtygier@yahoo.co.uk>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.1rc10 null pointer dereference ideapad_backlight_notify_power
References: <4E9EB1BC.9020709@yahoo.co.uk> <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 04:20 AM, David Rientjes wrote:
> On Wed, 19 Oct 2011, Sam Tygier wrote:
> 
>> In kernels 3.1rc9 and 3.1rc10 (from the ubuntu mainline repo) I get a crash
>> when disabling and then enabling the screen backlight with the alt+f2 key on a
>> lenovo ideapad S12 (intel version). The crash does not occur with 3.0 kernels
>> in ubuntu.  I have not tested earlier 3.1 rcs.
>>
>> The crash message scrolls to fast to see, it is not writen to a log, and i
>> dont see it on a USB serial console (I may be doing something wrong, but I do
>> see other messages during boot). I managed to get some photos of the message.
>> interesting parts are:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000008
>> IP: [<f807b29e>]  ideapad_backlight_notify_power+0x2e/0x40 [ideapad_laptop]
>> *pde = 00000000
>> Oops: 0002 [#1] SMP
>>
>> call trace functions:
>> ideapad_acpi_notify
>> acpi_device_notify
>> acpi_ev_notify_dispach
>> acpi_os_execute_deferred
>> process_one_work
>> ? acpi_os_wait_events_complete
>> ????????? can't read this one
>> kthread
>> kthread_bind
>> kernel_thread_helper
>>
>> i put the photos at http://www.hep.manchester.ac.uk/u/sam/pub/ideapad/
>>
>> if it would be helpfull, i could try a few more times for sharper photos.
>> please let me know if there is any other useful information you need.
>>
> 
> Looks light it may be changed via the acpi video driver where ->blight is 
> NULL.  Adding Ike and Matthew to the cc.
> 

This issue has been reported[1] and patch[2] is ready.

[1] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02340.html

[2] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02343.html
    http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02346.html

Thanks for reporting this issue.
