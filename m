Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2BGM0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:26:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50307 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772Ab2BGM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:26:32 -0500
X-Sasl-enc: GZKAK6QzC84myqGR6yk0td/rnWO+nDW/9QVhFDrsG1JN 1328617591
Message-ID: <4F3118F7.8050205@ladisch.de>
Date: Tue, 07 Feb 2012 13:28:39 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
References: <20120206181622.GA28811@kroah.com> <20120207084037.GA6140@citd.de> <4F30FABF.4060409@ladisch.de> <20120207105835.GA12864@citd.de> <4F310DBC.1040501@ladisch.de> <20120207114806.GA15323@citd.de>
In-Reply-To: <20120207114806.GA15323@citd.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
> On 07.02.2012 12:40, Clemens Ladisch wrote:
>> Matthias Schniedermeyer wrote:
>>> On 07.02.2012 11:19, Clemens Ladisch wrote:
>>>> Matthias Schniedermeyer wrote:
>>>>> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
>>>>
>>>> Please try that kernel parameter.
>>>
>>> I don't want/need ASPM, disabled is fine with me.
>>
>> In your case, it appears that sound requires ASPM.
>
> OK. I will try that later today.
>
> But i'm not hopeful because in syslog it says:
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> ...
> ACPI _OSC control for PCIe not granted, disabling ASPM
>
> So if ACPI doesn't want to relinquish control of ASPM, how is Linux
> supposed to enable it?

According to your logs, 3.2.4 didn't touch device 5:0, while 3.2.5 does
disable ASPM.  (Are there any other messages regarding 0000:05:00.0?)

It appears that this patch introduces new logic that forcibly disables
ASPM on pre-1.1 devices no matter what the BIOS says, although this
breaks your sound.

("Disable" can mean two things, tell the device to not do ASPM, or just
not tell the device anything.)


Regards,
Clemens
