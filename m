Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2KLCld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:41:33 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:47086 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2KLClb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:41:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121111210053.GA6436@elf.ucw.cz>
References: <CAJiejCRAZjNWGyJipfprHGptR2051Fdqf-10OkO0Yks7C2dQ0A@mail.gmail.com>
 <CAJiejCT8F18fH9yrtTDfHydFi6TDNdDWf8Ny7OATokf7EM-X1g@mail.gmail.com> <20121111210053.GA6436@elf.ucw.cz>
From: Drunkard Zhang <gongfan193@gmail.com>
Date: Mon, 12 Nov 2012 10:41:11 +0800
Message-ID: <CAJiejCT-UGTqo__rQ80rxke2ORkKAJEbiZekhfg0UwDoU5Qjrg@mail.gmail.com>
Subject: Re: Auto reboot when CPU at full load with X86_ACPI_CPUFREQ
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/12 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> I'm using Intel Xeon X5570 x2 with Asus Z8PE-D18, and experiencing
>> auto reboot when CPU full loaded for minutes, like building kernel
>> with "make -j17". After a lot of bisecting of config file, I found the
>> option leads to the reboot: X86_ACPI_CPUFREQ, both configed
>> X86_ACPI_CPUFREQ as a module or built in will lead to reboot.
>>
>> Config file finally bisected appended, config-3.7.0-rc3+-bad is the
>> one leads to reboot, config-3.7.0-rc3+-ok works OK. Hardware info also
>> appended.
>>
>> I think it is a bug, anything I can do? When the bug triggered, the
>> screen blanked immediately, any advice for me to debug? Happy to match
>> to code :-)
>>
>> This bug is CPU specific, with Xeon E5606 or E5620 it's all fine, just
>> triggered with Xeon X5570, or maybe all Xeon X serial.
>>
>> Tested kernel version: 3.1.x, 3.3.x, 3.5.x, 3.6.x, 3.7*, they are all affected.
>
> What does temperature do during those runs?
>                                                                 Pavel

CPU temperature didn't over 60 by degrees. I'm sure it's not hardware
faults, because without X86_ACPI_CPUFREQ it works fine, built in or
load as module it will reboot. I also configured some debug options to
catch something, but the reboot is too fast, dam. Any sugests?
