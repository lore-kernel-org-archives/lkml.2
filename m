Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992584Ab2JYTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:00:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44188 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100Ab2JYTAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:00:44 -0400
Message-ID: <50898C3D.8060004@zytor.com>
Date: Thu, 25 Oct 2012 12:00:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Enable A20 using KBC for some MSI laptops to fix S3
 resume
References: <201210242316.22028.linux@rainbow-software.org> <50885BBB.9010904@zytor.com> <201210251017.37750.linux@rainbow-software.org>
In-Reply-To: <201210251017.37750.linux@rainbow-software.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 01:17 AM, Ondrej Zary wrote:
> On Wednesday 24 October 2012, H. Peter Anvin wrote:
>> On 10/24/2012 02:16 PM, Ondrej Zary wrote:
>>> Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable
>>> A20 line but resume code assumes that KBC was used.
>>> The laptop will not resume from S3 otherwise but powers off after a while
>>> and then powers on again stuck with a blank screen.
>>>
>>> Fix it by enabling A20 using KBC. Affected laptop list and DMI data are
>>> from bug reports at Ubuntu Launchpad.
>>>
>>> Also add kernel parameter to easily activate this quirk on any system.
>>>
>>> Only compile tested. The original patch was tested with EX600 and PR200.
>>>
>>> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878
>>
>> Are we guaranteed that this executes *before* the keyboard driver
>> initializes?  If not, this needs to use the i8042 interface in the input
>> subsystem or at least acquire i8042_lock.
>>
>> 	-hpa
> 
> The code is called in:
> start_kernel()->setup_arch()->acpi_boot_table_init()
> 
> I think that it's before any drivers are initialized.
> 

Yes, that is very early indeed.  Could you please, however, put in a
comment that this is safe specifically because it is invoked long before
the i8042 driver can possibly initialize?

	-hpa


