Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1HDRjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:39:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab1HDRj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:39:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tkHZ+ITc/Koz18sRrlrVrlmcu5G3Itf7uYG7RGT8WI35gLwSfgY6jAwhKxnapzrjG
	j2d+weAqwPeYCE6gEozIg==
MIME-Version: 1.0
In-Reply-To: <20110804105657.GA27681@centrinvest.ru>
References: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
 <20110804105657.GA27681@centrinvest.ru>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Aug 2011 11:39:04 -0600
Message-ID: <CAErSpo5aE=cUPXf-bcrk8sNAWFCEAC2wQAvXZy7P9q5_A6=qMA@mail.gmail.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
To: Jeff Chua <jeff.chua.linux@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 4:56 AM, Andrey Panin <pazke@centrinvest.ru> wrote:
> On 209, 07 28, 2011 at 01:43:11PM +0800, Jeff Chua wrote:
>> I'm trying to access the serial port ttyS2 that is set in the BIOS as
>> "OS Controlled" without much success. If it's set it to "Always
>> Enabled",  I can access the serial port.
>>
>> This is on the Intermec CV60, and ttyS2 is the touchscreen port.
>>
>> # setserial /dev/ttyS2
>> /dev/ttyS2, UART: 16550A, Port: 0x03e8, IRQ: 6
>>
>>
>> If I set the BIOS to "OS Controlled", I can't access the serial port
>> no matter what parameter I pass to the setserial. The factory default
>> is "OS Controlled", and Window XP can detect and access the port.
>> There will be hundreds of CV60 to get into the BIOS to set it one by
>> one. If there's a way to access the port in linux, it'll be great!
>
> Does lspnp show this port in "OS Controlled" mode ?

It would definitely be interesting to know what lspnp says, but I
suspect there might be even more to it.

Linux can find UARTs via PNP (via PNPACPI on modern boxes).  But we
also poke blindly at the legacy I/O port addresses in
SERIAL_PORT_DFNS, which includes 0x3e8, so we should have found it
that way even if we didn't find it via PNP.

My guess is that in "OS Controlled" mode, the port is initially
powered off or disconnected, so we can't find it, and there's some
ACPI method that would turn it on.  Windows might be enabling it
automatically.

Can you also collect the DSDT so we can investigate this possibility?
There are instructions here:
http://kernel.org/pub/linux/kernel/people/helgaas/debug .  You might
want to open a bug report at http://bugzilla.kernel.org to have a
place to attach the DSDT and some dmesg logs.  I would start by filing
it under "ACPI / Config-Other".

Bjorn
