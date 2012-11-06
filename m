Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2KFMm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:42:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33511 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2KFMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:42:26 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <20121031173336.GA28991@kroah.com>
References: <20121031014527.GA2984@kroah.com>
	<2089727.VKpW8oC7hj@vostro.rjw.lan>
	<20121031173336.GA28991@kroah.com>
Date: Tue, 6 Nov 2012 16:42:24 +0400
X-Google-Sender-Auth: 7V8NxbRx893scowt9QIICgJqAHw
Message-ID: <CAAW1UO9BtAU5jpy=MqgFCwwXn3Gb8HA3m7FMktmQkYGqYrS0Rw@mail.gmail.com>
Subject: Re: ACPI errors with 3.7-rc3
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'v also have such errors on my macbook pro.

$ dmesg | tail
[17056.008564] ACPI Error: Method parse/execution failed
[\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
(20120711/psparse-536)
[17056.011194] ACPI Error: Method parse/execution failed
[\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
(20120711/psparse-536)
[17056.013793] ACPI Error: Method parse/execution failed
[\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
(20120711/psparse-536)
[17056.016383] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
[17056.511373] ACPI: EC: input buffer is not empty, aborting transaction
[17056.512672] ACPI Exception: AE_TIME, Returned by Handler for
[EmbeddedControl] (20120711/evregion-501)
[17056.515256] ACPI Error: Method parse/execution failed
[\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
(20120711/psparse-536)
[17056.517886] ACPI Error: Method parse/execution failed
[\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
(20120711/psparse-536)
[17056.520479] ACPI Error: Method parse/execution failed
[\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
(20120711/psparse-536)
[17056.523070] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)

And also loadavg is too high ~ 10
While there is no process that load CPU up to 100% or like that.
I think that this because of processes that is done in kernel space.
(basically that one who write such errors)

$ uname -a
Linux macbook-pro-sq 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
12:39:03 UTC 2012 x86_64 GNU/Linux

On Wed, Oct 31, 2012 at 9:33 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 31, 2012 at 10:11:21AM +0100, Rafael J. Wysocki wrote:
>> Hi Greg,
>>
>> On Tuesday, October 30, 2012 06:45:27 PM Greg KH wrote:
>> > Hi Len and Rafael,
>> >
>> > With 3.7-rc3, I'm seeing a constant stream of these errors in the kernel
>> > log for my MacBook Pro:
>> >
>> > [30443.430133] ACPI: EC: input buffer is not empty, aborting transaction
>> > [30443.430145] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
>> > [30443.430162] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
>> > [30443.430179] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
>> > [30443.430188] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
>> > [30443.430202] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
>> >
>> > They never showed up before in 3.7-rc2.
>> >
>> > Anything I should try out to resolve this?
>>
>> Well, there are the following two post-3.6 EC-related commits:
>>
>> commit 67bfa9b60bd689601554526d144b21d529f78a09
>> Author: Feng Tang <feng.tang@intel.com>
>> Date:   Fri Sep 28 15:22:01 2012 +0800
>>
>>     ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop
>>
>> commit a520d52e99b14ba7db135e916348f12f2a6e09be
>> Author: Feng Tang <feng.tang@intel.com>
>> Date:   Fri Sep 28 15:22:00 2012 +0800
>>
>>     ACPI: EC: Make the GPE storm threshold a module parameter
>>
>> Can you please check if reverting the second one helps?
>
> That last one seems like it would be it, if the module parameter got
> changed.  And now I can't duplicate it at all, 3.7-rc3 works fine.  Ick,
> sorry for the noise, I don't know what happened.  If I see the above
> errors again, I'll let you know, and I'll also check the ec module
> parameter first to ensure it didn't change from the default of 8.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Azat Khuzhin
