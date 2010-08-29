Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0H2Whw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 18:37:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45927 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0H2Whv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 18:37:51 -0400
Message-ID: <4C7AE0FF.6040104@kernel.org>
Date: Sun, 29 Aug 2010 15:36:47 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36-rc3
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com> <4C7ADEBD.3070906@kernel.org>
In-Reply-To: <4C7ADEBD.3070906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 03:27 PM, Yinghai Lu wrote:
> On 08/29/2010 12:24 PM, Torsten Kaiser wrote:
>> On Sun, Aug 29, 2010 at 7:25 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> You all know the drill by now: another week, another -rc.
>>
>> I'm still seeing the regression from -rc1 that the start of the early
>> serial output only contains garbage.
>>
>> I'm blaming commit 8fee13a48e4879fba57725f6d9513df4bfa8e9f3 (x86,
>> setup: enable early console output from the decompressor), because if
>> I'm disabling the new serial_putchar() in
>> arch/x86/boot/compressed/misc.c by putting "return;" in its first
>> line, the output returns to normal.
>>
>> Here the different outputs from the serial console:
>> Start of output from 2.6.35:
>> [    0.000000] Linux version 2.6.35 (root@treogen) (gcc version 4.4.4
>> (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Mon Aug 2 19:54:57 CEST
>> 2010
>> [    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
>> console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
>> video=1280x1024
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>
>> Start of output from 2.6.36-rc1..3:
>> {binary garbage}00000000 - 000000000009fc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>
>> Start of output with disabled serial_putchar():
>> [    0.000000] Linux version 2.6.36-rc3 (root@treogen) (gcc version
>> 4.4.4 (Gentoo 4.4.4-r1 p1.0, pie-0.4.5) ) #1 SMP Sun Aug 29 19:03:00
>> CEST 2010
>> [    0.000000] Command line: fastboot earlyprintk=serial,ttyS0,115200
>> console=ttyS0,115200 console=tty1 crypt_root=/dev/md3 radeon.modeset=1
>> video=1280x1024
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>
>> I can't see anything wrong with this commit, but it looks to me, as if
>> the newly added decompressor output gets corrupted somewhere. Could it
>> be my nondefault baud rate at 115200?
>>
> 
> please check if following work...

sorry. 

should be

debug fastboot console=tty1 console=uart8250,io,0x3f8,115200 crypt_root=/dev/md3 radeon.modeset=1 video=1280x1024 
 
and

fastboot console=tty1 console=uart8250,io,0x3f8,115200 crypt_root=/dev/md3 radeon.modeset=1 video=1280x1024 

Thanks

Yinghai Lu
