Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab0FBXSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:18:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43526 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab0FBXSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t6UETmQ6Z+C698aXCiWdqCyHgN+ibJOwk4/huIHwPJQ6krcJCpUuTlThqaSMXthTZS
         F0Wr9PfuskxVGSynh62lNf31yBCHACc0XP+tzj2uQW+TbkN5xU+BRAFEk65sXxKzkhAy
         GFuAaXL8xaSecBq+OtJIXR68vYtcTpiSCqxAo=
MIME-Version: 1.0
In-Reply-To: <4C05F3BF.6090503@gmail.com>
References: <20100601192101.GA15086@srcf.ucam.org>
	<4C056839.8020605@gmail.com>
	<20100601200704.GA16091@srcf.ucam.org>
	<4C056AE6.3000409@gmail.com>
	<20100601202130.GA16391@srcf.ucam.org>
	<4C056E0C.2030709@gmail.com>
	<20100601203351.GA16575@srcf.ucam.org>
	<4C0572B4.6000201@gmail.com>
	<20100601211219.GA17719@srcf.ucam.org>
	<4C057AE9.9020307@gmail.com>
	<20100601212901.GA18390@srcf.ucam.org>
	<4C057EF0.2030808@gmail.com>
	<4C05E800.1010400@gmail.com>
	<4C05F3BF.6090503@gmail.com>
Date: Wed, 2 Jun 2010 17:18:19 -0600
Message-ID: <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
From: Robert Hancock <hancockrwd@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 12:01 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
>> Can you post the FACP section of the acpidump output from this machine?
>>
>
> here you go:
>


>             Reset Register Supported (V2) : 1

> [074h 116 12]               Reset Register : <Generic Address Structure>
> [074h 116  1]                     Space ID : 01 (SystemIO)
> [075h 117  1]                    Bit Width : 08
> [076h 118  1]                   Bit Offset : 00
> [077h 119  1]                 Access Width : 00
> [078h 120  8]                      Address : 0000000000000CF9
>
> [080h 128  1]         Value to cause reset : 06

Hmm, so the FADT says the reset register is listed as supported, and
says writing 0x06 to 0xCF9 is supposed to do it.. That's exactly what
this should do:

#include <sys/io.h>

int main() {
    iopl(3);
    outb(6, 0xcf9);
    return 0;
}

but you said that didn't do anything.. It kind of seems like ACPI
reboot is busted on this machine then, but then I wonder how Windows
manages to work..
