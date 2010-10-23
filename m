Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0JWQIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:08:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51589 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab0JWQIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YpxyyHnjln1ceVZWb8QF6S2WjRYMNPoOiyg7zEOVuXj2WBSF1G2OgQC07pBRFHl/VW
         qD+kBcS40Di+LoCYzfqzU0grNKJ/a1INvPEEKTNmJUwcY01nufSncta5C5tGgdrDiCd5
         0VdQnLX23CAEEd7wemalYVs1zcXh1inw6BKgM=
MIME-Version: 1.0
In-Reply-To: <4CC303FD.1000802@teksavvy.com>
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
	<4CC24186.1040001@teksavvy.com>
	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>
	<4CC2FD0A.9090409@teksavvy.com>
	<AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
	<4CC303FD.1000802@teksavvy.com>
Date: Sat, 23 Oct 2010 17:08:29 +0100
Message-ID: <AANLkTin9wiBZjkeKxYKnJaSA1vxs8ELGTWYVMM1DfYKu@mail.gmail.com>
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good! (that it's not a media error) I've ran extended SMART tests on
the drive as well, and everything seemed fine.

I'm going to try with 2.6.35 series now, see if I can salvage some data.

Thanks,

// Mathias

On 23 October 2010 16:49, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-10-23 11:20 AM, Mathias Burén wrote:
>>
>> Hi,
>>
>> Interesting, as the badblocks program doesn't think these sectors are
>> bad. Can I test them any other way?
>
> ..
>>
>> On 23 October 2010 16:19, Mark Lord<kernel@teksavvy.com>  wrote:
>>>
>>> On 10-10-23 08:57 AM, Mathias Burén wrote:
>
> ..
>>>>
>>>> ata2.00: status: { DRDY }
>>>> ata2: hard resetting link
>>>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>> ata2.00: configured for UDMA/133
>>>> ata2.00: device reported invalid CHS sector 0
>>>> sd 1:0:0:0: [sdb]  Result: hostbyte=0x00 driverbyte=0x08
>>>> sd 1:0:0:0: [sdb]  Sense Key : 0xb [current] [descriptor]
>>>> Descriptor sense data with sense descriptors (in hex):
>>>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>>>         00 00 00 00
>>>> sd 1:0:0:0: [sdb]  ASC=0x0 ASCQ=0x0
>>>> sd 1:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 e7 70 c8 e8 00 05 40 00
>>>> end_request: I/O error, dev sdb, sector 3882928360
>>>> md/raid:md0: read error not correctable (sector 3882926312 on sdb1).
>>>> md/raid:md0: Disk failure on sdb1, disabling device.
>>>
>>>
>>> No, that error looks like a real disk media error -- bad sector(s) on the
>>> drive.
>>>
>>> The BIOS issue merely gives corrupted data, not read errors.
>
> MMm.. you're right.
> I just now looked at the full dmesg you posted,
> and those are NOT media errors.
>
> It looks like NCQ commands are behaving strangely for some reason
> in your 2.6.36 kernel.
>
> Can you retest with, say, 2.6.34 ?
> There were a number of sata_mv updates in between,
> and I'm wondering if perhaps one of them broke something?
>
> Or if you just want to stabilize things, then turn off NCQ.
>
> Cheers
>
