Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2EAQ1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:27:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40121 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754006Ab2EAQ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:27:21 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/rnKYVMlXrRADzmaWSP5epdqwNEOEUrDBDDMfliJ
	8T6nIy1AWtkyr0
Message-ID: <4FA00EE5.2060403@fisher-privat.net>
Date: Tue, 01 May 2012 18:27:17 +0200
From: "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
References: <Pine.LNX.4.44L0.1205011004030.1499-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1205011004030.1499-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.05.2012 16:11, Alan Stern wrote:
> On Tue, 1 May 2012, Rafael J. Wysocki wrote:
>
>>> I mean not just the mapping.
>>> I mean PCI:PME_SUP field.  If it PME(D0+,D1-,D2-,D3hot+,D3cold+), and
>>> acpi trying to avoid D3 states for this device. then is is same like
>>> PME(D0+,D1-,D2-)? Or not?
>>
>> Yes, if _S3D or _S3W are present.  If they are not present and _PRW is,
>> that means "don't care".
>>
>>> According to spec.:
>>> 7.2 Device Power Management Objects (page 287)
>>> _S3D - Highest D-state supported by the device in the S3 state
>>> _S3W - Lowest D-state supported by the device in the S3 state which can
>>> wake the system.
>>> by definition if _S3W is specified then we can assume, the device can
>>> wake? But _SxW is not defined.
>>
>> The device can wake up the system if _PRW is present for it (and for
>> PCIe devices even that is not formally necessary).
>>
>>> Are there any other method to forbid the system use broken state, after
>>> device was actually produced? Usual BIOS flash utility will probably no
>>> rewrite the PCIs EEPROM. Only hope is ACPI, what is correct method to do
>>> define it by ACPI?
>>
>> Define _S3D that will return 2 (for example) and _PRW returning 3 as the
>> deepest sleep state the system may be woken up from.  Then, we'll use
>> D2 (after the @subject patch).
>>
>> The drawback is that the kernel will then think the device can wake up
>> the system.
>
> There also remains a question about runtime power states and resume.
>
> Oleksij, with your patch, which state does the controller get put into
> during runtime suspend, D2 or D3?  (You may need to enable runtime
> suspend by doing
>
> 	echo auto>/sys/bus/pci/devices/0000:00:1d.0/power/control
>
> in order to test this.)  And if the controller is in runtime suspend,
> does it resume correctly when you plug in a new USB device?
>
> I'm pretty sure that without the patch, the controller gets put into D3
> and resume does work.

I do not know if device really suspended, but every thing works like 
before. New usb devices are recognized and working.

