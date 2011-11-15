Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1KOHJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:09:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62957 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab1KOHJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:09:52 -0500
MIME-Version: 1.0
X-Originating-IP: [165.228.146.52]
In-Reply-To: <201111142118.47256.maciej.rutecki@gmail.com>
References: <4EBAC3B5.5060405@gmail.com> <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com> <201111142118.47256.maciej.rutecki@gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 15 Nov 2011 18:09:28 +1100
Message-ID: <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
Subject: Re: Regression in thinkpad-acpi events
To: maciej.rutecki@gmail.com
Cc: Natanji <natanji@gmail.com>, linux-acpi@vger.kernel.org, lenb@kernel.org,
        ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 7:18 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> (add more CCs)
>
> On poniedziałek, 14 listopada 2011 o 20:44:14 Natanji wrote:
>> With 3.0 it was still fine, that much is for sure. The problem came
>> with the upgrade to 3.1. I've never even compiled my own kernel so I
>> cannot bisect. Sorry...
>>
>> Regards,
>> Natanji
>>
>> On Mon 14 Nov 2011 08:31:06 PM CET, Maciej Rutecki wrote:
>> > On środa, 9 listopada 2011 o 19:17:25 Natanji wrote:
>> >> Hello everyone,
>> >> first time posting on this last, and I'm not subscribed, so please CC
>> >> any replies to me. ;)
>> >>
>> >> I'm running Kernel version 3.1-4 using Arch Linux (32 Bit) on a Thinkpad
>> >> X60 Tablet. Since upgrading from a pre-3.1 kernel to a post-3.1 kernel,
>> >> the Thinkpad-specific ACPI events (from thinkpad-acpi) are completely
>> >> gone.
>> >>
>> >> This can be observed by using the acpi_listen command. For instance, no
>> >> ACPI events happen when swiveling the display, and the sleep button
>> >> returns
>> >>
>> >>    button/sleep SBTN 00000080 00000000
>> >>
>> >> instead of the previous
>> >>
>> >>    ibm/hotkey HKEY 00000080 00001004
>> >>
>> >> The bug was reported in the Arch Linux bugtracker [1] and it was
>> >> suggested to report this upstream, so this is what I did now. Sadly I
>> >> have no idea how I could find out if this is indeed a kernel bug or not;
>> >> I have never compiled my own kernel so what I can give you is probably
>> >> limited. But I suppose quite a few members of this list use a Thinkpad.
>> >> If there is anything else I can help out with, just tell me.
>> >>
>> >> [1] https://bugs.archlinux.org/index.php?do=details&task_id=26658
>> >
>> > Can you check that 3.1 works or not? Or try bisection that it is
>> > regression after 3.0 or 3.1 kernel.

I'm observing the same, also with Arch Linux, and a ThinkPad x60:
# uname -a
Linux x60 3.1.1-1-ARCH #1 SMP PREEMPT Fri Nov 11 22:28:29 CET 2011
x86_64 Intel(R) Core(TM)2 CPU T7200 @ 2.00GHz GenuineIntel GNU/Linux

The kernel config can be found here:
<http://projects.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/linux>.

As requested:
# grep . /sys/bus/platform/devices/thinkpad*/*
/sys/bus/platform/devices/thinkpad_acpi/bluetooth_enable:1
grep: /sys/bus/platform/devices/thinkpad_acpi/cmos_command: Permission denied
/sys/bus/platform/devices/thinkpad_acpi/hotkey_all_mask:0x00ffffff
/sys/bus/platform/devices/thinkpad_acpi/hotkey_bios_enabled:0
/sys/bus/platform/devices/thinkpad_acpi/hotkey_bios_mask:0x0000080c
/sys/bus/platform/devices/thinkpad_acpi/hotkey_enable:1
/sys/bus/platform/devices/thinkpad_acpi/hotkey_mask:0x008dffff
/sys/bus/platform/devices/thinkpad_acpi/hotkey_poll_freq:10
/sys/bus/platform/devices/thinkpad_acpi/hotkey_radio_sw:1
/sys/bus/platform/devices/thinkpad_acpi/hotkey_recommended_mask:0x008dffff
/sys/bus/platform/devices/thinkpad_acpi/hotkey_report_mode:1
/sys/bus/platform/devices/thinkpad_acpi/hotkey_source_mask:0x00000000
/sys/bus/platform/devices/thinkpad_acpi/modalias:platform:thinkpad_acpi
/sys/bus/platform/devices/thinkpad_acpi/uevent:DRIVER=thinkpad_acpi
/sys/bus/platform/devices/thinkpad_acpi/uevent:MODALIAS=platform:thinkpad_acpi
/sys/bus/platform/devices/thinkpad_acpi/wakeup_hotunplug_complete:0
/sys/bus/platform/devices/thinkpad_acpi/wakeup_reason:0
/sys/bus/platform/devices/thinkpad_hwmon/fan1_input:2780
/sys/bus/platform/devices/thinkpad_hwmon/modalias:platform:thinkpad_hwmon
/sys/bus/platform/devices/thinkpad_hwmon/name:thinkpad
/sys/bus/platform/devices/thinkpad_hwmon/pwm1:255
/sys/bus/platform/devices/thinkpad_hwmon/pwm1_enable:2
/sys/bus/platform/devices/thinkpad_hwmon/temp10_input:49000
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp11_input: No such
device or address
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp12_input: No such
device or address
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp13_input: No such
device or address
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp14_input: No such
device or address
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp15_input: No such
device or address
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp16_input: No such
device or address
/sys/bus/platform/devices/thinkpad_hwmon/temp1_input:62000
/sys/bus/platform/devices/thinkpad_hwmon/temp2_input:56000
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp3_input: No such
device or address
/sys/bus/platform/devices/thinkpad_hwmon/temp4_input:58000
/sys/bus/platform/devices/thinkpad_hwmon/temp5_input:37000
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp6_input: No such
device or address
/sys/bus/platform/devices/thinkpad_hwmon/temp7_input:37000
grep: /sys/bus/platform/devices/thinkpad_hwmon/temp8_input: No such
device or address
/sys/bus/platform/devices/thinkpad_hwmon/temp9_input:46000
/sys/bus/platform/devices/thinkpad_hwmon/uevent:DRIVER=thinkpad_hwmon
/sys/bus/platform/devices/thinkpad_hwmon/uevent:MODALIAS=platform:thinkpad_hwmon
