Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab0FCA1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:27:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61819 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933344Ab0FCA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qebxlXoBXiL/AzXlx4dmLTm4TPkUsixcf6nJWBCqgoX4Zsdeq3qG4+1KR1QzKJ4W66
         JyvDpxfoWKXNZhhu+XMJOJayvJEzbvQ0QpXHTTYmKmmpyJeBNlcVjd+tUGqpDXOwcnGn
         STwkqO+81aUlYp+xdzN9wozIvCNomvXOmgDkY=
Message-ID: <4C06F6EA.6090701@gmail.com>
Date: Wed, 02 Jun 2010 17:27:22 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601192101.GA15086@srcf.ucam.org>	<4C056839.8020605@gmail.com>	<20100601200704.GA16091@srcf.ucam.org>	<4C056AE6.3000409@gmail.com>	<20100601202130.GA16391@srcf.ucam.org>	<4C056E0C.2030709@gmail.com>	<20100601203351.GA16575@srcf.ucam.org>	<4C0572B4.6000201@gmail.com>	<20100601211219.GA17719@srcf.ucam.org>	<4C057AE9.9020307@gmail.com>	<20100601212901.GA18390@srcf.ucam.org>	<4C057EF0.2030808@gmail.com>	<4C05E800.1010400@gmail.com>	<4C05F3BF.6090503@gmail.com>	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>	<4C06ECAA.3060708@gmail.com>	<4C06ED18.2010400@gmail.com>	<4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
In-Reply-To: <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 05:20 PM, Robert Hancock wrote:
> On Wed, Jun 2, 2010 at 6:05 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>>>>> Hmm, so the FADT says the reset register is listed as supported, and
>>>>> says writing 0x06 to 0xCF9 is supposed to do it.. That's exactly what
>>>>> this should do:
>>>>>
>>>>> #include<sys/io.h>
>>>>>
>>>>> int main() {
>>>>> iopl(3);
>>>>> outb(6, 0xcf9);
>>>>> return 0;
>>>>> }
>>>>>
>>>>> but you said that didn't do anything.. It kind of seems like ACPI
>>>>> reboot is busted on this machine then, but then I wonder how Windows
>>>>> manages to work..
>>>>>
>>>>
>>>>
>>>> alright!! I have a better idea at what this is now..
>>>> as for the above code, yes this one segfaults,
>>>> the other code posted on the thread just returns
>>>> a command prompt(testing:
>>>
>>> You get a segfault on that one? Running as root?
>>>
>>
>> my bad(tired)I left out iopl(3);
>> in the code which was giving a segfault.
>>
>> running the below code(s) just gives a command prompt
>>
>> int main() {
>>         iopl(3);
>>         outb(0xfe, 0xcf9);
>>         return 0;
>> }
>>
>> int main() {
>>         iopl(3);
>>         outb(6, 0xcf9);
>>         return 0;
>> }
>
> What if you do:
>
> #include<unistd.h>
>
> int main() {
>          iopl(3);
>          outb(2, 0xcf9);
>          sleep(1);
>          outb(6, 0xcf9);
>          return 0;
> }
>
> That's basically what PCI reboot does.
>
> It's possible it doesn't take the first time - you could try modifying
> drivers/acpi/reboot.c to call acpi_reset in a loop instead of just
> trying once (assuming you have the patch to default to ACPI reboot
> enabled).
>

the above code reboot's the machine as it should..
I can look at that(need to take a break first though)
and see..

what about the whole kbd mechanism(0x64) give the info I provided
does it look possible, or is this machine strictly on cf9?

cheers,

Justin P. Mattock
