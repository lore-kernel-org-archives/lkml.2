Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab0GNSfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:35:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab0GNSfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:35:38 -0400
Message-ID: <4C3E0376.4090707@zytor.com>
Date: Wed, 14 Jul 2010 11:35:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com>
In-Reply-To: <4C3DC64F.5040505@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 07:14 AM, Ben Greear wrote:
> On 07/13/2010 08:29 PM, Robert Hancock wrote:
>> On Tue, Jul 13, 2010 at 8:22 PM, Ben Greear<greearb@candelatech.com>  wrote:
>>>> Can you print out bus->number and devfn and look that up in lspci to
>>>> find out which device it's hitting? It looks like there's a device with
>>>> a PCI Express extended capability header that has a extended capability
>>>> ID of 0000h and a next capability offset of 100h, which points to
>>>> itself, causing the infinite loop. I'm guessing that if pcie_cap>>  20
>>>> <= pos then it should give up and break out of the loop, since it means
>>>> that the next capability pointer is invalidly pointing to the same or a
>>>> previous entry..
>>>
>>> Bailing out like that does let it boot.
>>>
>>> As for the bus and devfn:  bus: 0   devfn: 129 (decimal)
>>>
>>> I'm not sure what to look for in lspci, but here is the output with -n:
>>
>> That will be device 0x10 function 1, this one:
>>
>> 00:10.1 0600: 8086:25f0 (rev b1)
>>
>> Intel 5000 Series Chipset FSB Registers, apparently.. What does lspci
>> -vv show for that device?
> 
> 00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers (rev b1)
> 	Subsystem: Super Micro Computer Inc Unknown device 9780
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Kernel modules: i5000_edac, i5k_amb
> 

Could you get the output of lspci -vv -xxxx for this device?  I'm
confused why this device would identify as having extended config space...

	-hpa
