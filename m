Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0JWPtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:49:20 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:43413 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757743Ab0JWPtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:49:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAFygwkxLd/sX/2dsb2JhbAAHgxjIaJFagSKDMnQEj1E
X-IronPort-AV: E=Sophos;i="4.58,228,1286164800"; 
   d="scan'208";a="80488075"
Message-ID: <4CC303FD.1000802@teksavvy.com>
Date: Sat, 23 Oct 2010 11:49:17 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>	<4CC24186.1040001@teksavvy.com>	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>	<4CC2FD0A.9090409@teksavvy.com> <AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
In-Reply-To: <AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-23 11:20 AM, Mathias Burén wrote:
> Hi,
>
> Interesting, as the badblocks program doesn't think these sectors are
> bad. Can I test them any other way?
..
> On 23 October 2010 16:19, Mark Lord<kernel@teksavvy.com>  wrote:
>> On 10-10-23 08:57 AM, Mathias Burén wrote:
..
>>> ata2.00: status: { DRDY }
>>> ata2: hard resetting link
>>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> ata2.00: configured for UDMA/133
>>> ata2.00: device reported invalid CHS sector 0
>>> sd 1:0:0:0: [sdb]  Result: hostbyte=0x00 driverbyte=0x08
>>> sd 1:0:0:0: [sdb]  Sense Key : 0xb [current] [descriptor]
>>> Descriptor sense data with sense descriptors (in hex):
>>>          72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>>          00 00 00 00
>>> sd 1:0:0:0: [sdb]  ASC=0x0 ASCQ=0x0
>>> sd 1:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 e7 70 c8 e8 00 05 40 00
>>> end_request: I/O error, dev sdb, sector 3882928360
>>> md/raid:md0: read error not correctable (sector 3882926312 on sdb1).
>>> md/raid:md0: Disk failure on sdb1, disabling device.
>>
>>
>> No, that error looks like a real disk media error -- bad sector(s) on the drive.
>>
>> The BIOS issue merely gives corrupted data, not read errors.

MMm.. you're right.
I just now looked at the full dmesg you posted,
and those are NOT media errors.

It looks like NCQ commands are behaving strangely for some reason
in your 2.6.36 kernel.

Can you retest with, say, 2.6.34 ?
There were a number of sata_mv updates in between,
and I'm wondering if perhaps one of them broke something?

Or if you just want to stabilize things, then turn off NCQ.

Cheers
