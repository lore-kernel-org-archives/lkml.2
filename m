Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2KFNE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:04:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46396 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KFNE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:04:26 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <20121106124826.GA21806@kroah.com>
References: <20121031014527.GA2984@kroah.com>
	<2089727.VKpW8oC7hj@vostro.rjw.lan>
	<20121031173336.GA28991@kroah.com>
	<CAAW1UO9BtAU5jpy=MqgFCwwXn3Gb8HA3m7FMktmQkYGqYrS0Rw@mail.gmail.com>
	<20121106124826.GA21806@kroah.com>
Date: Tue, 6 Nov 2012 17:04:26 +0400
X-Google-Sender-Auth: k9UYDYDip2f427cC62EXtGp5qlc
Message-ID: <CAAW1UO__wyEbPW=aXo0fy8HE931mhSXhdq6AYdrxfd30rEfTpA@mail.gmail.com>
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

When this messages appears, I was running from AC, not from battery.

On Tue, Nov 6, 2012 at 4:48 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 06, 2012 at 04:42:24PM +0400, Azat Khuzhin wrote:
>> I'v also have such errors on my macbook pro.
>>
>> $ dmesg | tail
>> [17056.008564] ACPI Error: Method parse/execution failed
>> [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
>> (20120711/psparse-536)
>> [17056.011194] ACPI Error: Method parse/execution failed
>> [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
>> (20120711/psparse-536)
>> [17056.013793] ACPI Error: Method parse/execution failed
>> [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
>> (20120711/psparse-536)
>> [17056.016383] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
>> [17056.511373] ACPI: EC: input buffer is not empty, aborting transaction
>> [17056.512672] ACPI Exception: AE_TIME, Returned by Handler for
>> [EmbeddedControl] (20120711/evregion-501)
>> [17056.515256] ACPI Error: Method parse/execution failed
>> [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88026547ea10), AE_TIME
>> (20120711/psparse-536)
>> [17056.517886] ACPI Error: Method parse/execution failed
>> [\_SB_.BAT0.UBST] (Node ffff88026547e678), AE_TIME
>> (20120711/psparse-536)
>> [17056.520479] ACPI Error: Method parse/execution failed
>> [\_SB_.BAT0._BST] (Node ffff88026547e740), AE_TIME
>> (20120711/psparse-536)
>> [17056.523070] ACPI Exception: AE_TIME, Evaluating _BST (20120711/battery-464)
>
> I'm seeing this again right now.  I'm wondering if it's because I'm
> running on battery power at the moment:
>
> [41694.309264] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
> [41694.309282] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
> [41694.309300] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
> [41694.309310] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
> [41694.309324] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
> [41694.809093] ACPI: EC: input buffer is not empty, aborting transaction
>
> ec_storm_threshold is still set to 8 in /sys/module/acpi/parameters/ so that's
> not the issue here.
>
>> And also loadavg is too high ~ 10
>> While there is no process that load CPU up to 100% or like that.
>> I think that this because of processes that is done in kernel space.
>> (basically that one who write such errors)
>>
>> $ uname -a
>> Linux macbook-pro-sq 3.6.5macbook-pro-custom-v0.1 #4 SMP Sun Nov 4
>> 12:39:03 UTC 2012 x86_64 GNU/Linux
>
> Ah, ok, that means it's not something new in 3.7-rc, so maybe it's just never
> worked properly for this hardware :)
>
> So it's not a regression, just an ACPI issue, any ACPI developer have an idea
> about this?
>
> thanks,
>
> greg k-h



-- 
Azat Khuzhin
