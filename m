Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0EaXmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:42:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43540 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0EaXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=URGW9pz659RgjTlINgFmWl46MVKO5coHX6tZ9X1w3dLiVKoxL0gn8m1N08E//HsqD0
         0C4OBWXcvmLVCIVKcrzQ5/HNqeDJL+ivUU6ZykuiBgn7JalmdhUAM4YjnIqSqeojrLMR
         jOXiJWxhJWz7oGxdP+XuYjn31mAphmnRVxIRo=
Message-ID: <4C04496E.3000303@gmail.com>
Date: Mon, 31 May 2010 17:42:38 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Richard Tillmore <rtillmore@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: resource piix4_smbus conflicts with ACPI region SMRG
References: <AANLkTinmBxzM4IEgrY6gqokDhLJDrVyKd0cu75VaFR8Q@mail.gmail.com>
In-Reply-To: <AANLkTinmBxzM4IEgrY6gqokDhLJDrVyKd0cu75VaFR8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 04:12 PM, Richard Tillmore wrote:
> Hi,
>
> I was running 2.6.30 until I had time to update.  Being a long weekend
> I upgraded to 2.6.34-rc6 and noticed a few new messages in dmesg.  I
> then installed 2.6.34 and the messages remain.
>
> PCI: Ignoring host bridge windows from ACPI; if necessary, use
> "pci=use_crs" and report a bug
> ACPI: PCI Root Bridge [PCI0] (0000:00)

This is just an informational message.

>
> ACPI: resource piix4_smbus [io  0x0440-0x0447] conflicts with ACPI
> region SMRG [??? 0x00000440-0x0000044f flags 0x47]
> ACPI: If an ACPI driver is available for this device, you should use
> it instead of the native driver
>
> The system is a Tyan Tiger S1832 motherboard with a P3 850Mhz
> processor running the latest bios.  Everything appears to work
> properly so I am unsure what the messages mean beyond the obvious.  I
> did a little research and was wondering if this is related to the no
> bootmem patches.  I have:

Unless you need to use anything on SMBus (hardware sensors, essentially) 
you don't have to worry about that one. It means that the kernel has 
detected that the BIOS may potentially access the SMBus controller which 
may conflict with usage of the controller from within the OS.
