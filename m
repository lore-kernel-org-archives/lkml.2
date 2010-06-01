Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0FAVZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:25:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46136 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0FAVZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yHTZiUcjRYHF0PPhPehA5qbrnK5S4xCkynRJNX4vmgj8q1bZPa05ooy3LdyXfRnZxU
         YHdAC6Oxq5kUz1uJw46edvEfLSUG92vCBLqg9dWmkI8ua26T62Wx3QKnX+1zzlZ/0Kvh
         U4R84AEIut4abLVY0br/1JnyJNhltegUgb+j4=
Message-ID: <4C057AE9.9020307@gmail.com>
Date: Tue, 01 Jun 2010 14:26:01 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: x86@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to	pci_reboot_dmi_table.
References: <20100601190050.GA14667@srcf.ucam.org> <4C055BFF.8090800@gmail.com> <20100601192101.GA15086@srcf.ucam.org> <4C056839.8020605@gmail.com> <20100601200704.GA16091@srcf.ucam.org> <4C056AE6.3000409@gmail.com> <20100601202130.GA16391@srcf.ucam.org> <4C056E0C.2030709@gmail.com> <20100601203351.GA16575@srcf.ucam.org> <4C0572B4.6000201@gmail.com> <20100601211219.GA17719@srcf.ucam.org>
In-Reply-To: <20100601211219.GA17719@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 02:12 PM, Matthew Garrett wrote:
> On Tue, Jun 01, 2010 at 01:51:00PM -0700, Justin P. Mattock wrote:
>> On 06/01/2010 01:33 PM, Matthew Garrett wrote:
>>> On Tue, Jun 01, 2010 at 01:31:08PM -0700, Justin P. Mattock wrote:
>>> It returns you to the prompt? The machine hangs? What do you mean by
>>> "nothing"? (Also, what chipset does this machine have?)
>>>
>>
>> this is what it does:
>> It returns you to the prompt
>
> Ok, so it does nothing. Sigh. Thapple.
>

responds the same way..

>> as for the chipset name..(not sure)
>
> It's an MCP79. In that case I suspect that we're misdiagnosing this at

alright.. yeah it's MCP79

> some level. How about the following (again, run as root):
>
> #include<sys/io.h>
>
> int main() {
> 	iopl(3);
> 	outb(0xfe, 0x64);
> 	return 0;
> }
>

ahh!! I see now:
grep 0x64 *.dsl


Sleep (0x64)
                     Sleep (0x64)
             Sleep (0x64)
                 OperationRegion (P64, PCI_Config, 0x64, 0x02)
                 Name (M73L, 0x64)
                 Divide (Local1, 0x64, , Local0)
                                 Sleep (0x64)


Justin P. Mattock
