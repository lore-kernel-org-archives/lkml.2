Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab1EROBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:01:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4503 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab1EROBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jBJCiMlaQQIJYWw1GV1YyK7gTo+xhITk/6r54gjBMI3i3kYkA6xJF02LYUpUl+iHtn
         4dzs0GzSyZS/fiX8ZVdg==
MIME-Version: 1.0
In-Reply-To: <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
 <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com> <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 18 May 2011 07:56:04 -0600
Message-ID: <BANLkTimX1KG-BZ98LH_NweOUOaUbQtZirg@mail.gmail.com>
Subject: Re: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
To: "Hornung, Michael" <mhornung@init-ka.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 1:44 AM, Hornung, Michael <mhornung@init-ka.de> wrote:
>>> There is an UART (FPGA IP Core) in that system located at address 1900h using interrupt 3. In order to get Kernel messages at boot time,
>>> I changed file arch/x86/include/asm/serial.h as follows:
>>>
>>> -        { 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },      /* ttyS0 */     \
>>> +        { 0, BASE_BAUD, 0x1900, 3, STD_COM_FLAGS },     /* ttyS0 */    \
>>>
>>> that is the only change I made to the kernel sources.
>
>> Is this UART connected via PCI?  I don't think so, because I don't see
>> any I/O BARs that include 0x1900.
>
> The UART is connected via LPC bus.

Makes sense; that's a common way for attaching UARTs, and they are
normally described via ACPI.  When you do that, I think it will show
up as ttyS4 (be sure you build with CONFIG_SERIAL_8250_PNP=y), so
you'll have to use "console=ttyS4" when you boot.  ttyS0-ttyS3 are
taken by the hard-coded ports in serial.h, even though they may not
exist on your platform.

Bjorn
