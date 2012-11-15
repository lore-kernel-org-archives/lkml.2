Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767886Ab2KOOE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:04:59 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:56680 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767797Ab2KOOE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:04:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211151450140.15877@pobox.suse.cz>
References: <1352731379-24683-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1211151450140.15877@pobox.suse.cz>
Date: Thu, 15 Nov 2012 15:04:54 +0100
Message-ID: <CAN+gG=FeNBzdbBcH6uSWB_rUOS6PjyjpVSuY3b--g1mXo17fXA@mail.gmail.com>
Subject: Re: [PATCH v3] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        JJ Ding <jj_ding@emc.com.tw>, Jiri Slaby <jslaby@suse.cz>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 2:51 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 12 Nov 2012, Benjamin Tissoires wrote:
>
>> Microsoft published the protocol specification of HID over i2c:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh852380.aspx
>>
>> This patch introduces an implementation of this protocol.
>>
>> This implementation does not includes the ACPI part of the specification.
>> This will come when ACPI 5.0 devices enumeration will be available.
>>
>> Once the ACPI part is done, OEM will not have to declare HID over I2C
>> devices in their platform specific driver.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>
> Out of curiosity -- has this been tested on a real device (is there any
> such device available anyway?), or is that just the implementation of the
> defined protocol?

It has been tested on an ELAN microelectronics device (a prototype),
on an odroid-x board. That's how we figure out the bug in the
set_report command.
I think we manage to test all main features of the protocol
(get_report, irqs, hid descriptor, report descriptors, set_report).

I'm currently waiting for a Synaptics touchpad to check if it's also
working with their devices.

The thing is that HID over i2c for x86 platform will presumably
require the Haswell platform from Intel (we need ACPI 5 for
enumeration), but it would be very nice to get this in the kernel just
before hardware arrive on the market :)
However, I won't be surprise if android OEMs also start using this
specification because it won't force them to write kernel drivers...

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
