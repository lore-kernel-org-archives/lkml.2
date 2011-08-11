Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1HKRzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:55:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1HKRzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:55:04 -0400
Message-ID: <4E441774.2040904@gmail.com>
Date: Thu, 11 Aug 2011 19:55:00 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] x86 EFI boot stub
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>  <4E43D3AE.70901@gmail.com> <1313075678.3436.69.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1313075678.3436.69.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 08/11/2011 05:14 PM, Matt Fleming wrote:
> On Thu, 2011-08-11 at 15:05 +0200, Maarten Lankhorst wrote:
>> On 08/11/2011 12:59 PM, Matt Fleming wrote:
>>> From: Matt Fleming <matt.fleming@intel.com>
>>>
>>> This series adds support for an EFI boot stub, similar to the existing
>>> BIOS boot stub. The result is that you can boot a bzImage on an EFI
>>> machine without the use of a boot loader by making the bzImage appear
>>> to the EFI firmware to be an EFI application. Also, a single bzImage
>>> can be booted on either a BIOS or EFI machine.
>>>
>>> Using the EFI boot stub has the advantage that the kernel is
>>> responsible for configuring the machine to the point where we can
>>> fully boot the kernel, so we are no longer at the mercy of the boot
>>> loader.
>>>
>> Fails to boot here. I thought changing characteristics from 0x60500020 to 0xe0500020 would help, but no. :/
>> This change would make the code section writable.
> Thanks for testing out the patches Maarten!
>
>> FileAlignment you use is probably wrong, I think it should be 0x200 not 0x2000 .
> Yep, thanks. That looks like a typo.
>
>> Maybe you need to add a data section and fix SizeOfInitializedData too?
> Hmm.. possibly. Is this on x86-64?
Yeah the system I'm testing on is 64-bits, if it you get this one working I can check if my old mac mini supports 32-bits efi too.
>> It just hangs on a blinking cursor, no idea if it actually started executing anything yet or not, since nothing is printed out.
> Hmm.. do you have early printk enabled? Can you hook up a serial console
> to this machine?
>
I get no output on serial console with vmlinuz.efi so it crashes before 'early console in decompress_kernel' is printed.

~Maarten
