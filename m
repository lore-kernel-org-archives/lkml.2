Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0JWPUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:20:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32944 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab0JWPUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=maJqNGnphbj/mqYtReo/cynfkzCZAJu416fZRq8BSN4wvMUFWPXsPV4zbQCS2ZkNhJ
         1BCCu4FSL6FSKRJecxxx/FyP/374NNOuKnhfeM2K3gAkbt+qZd/DtWzwfHvwea0qZ1I4
         wUXHAcFwtnP4w/6XvoEQvbUbtTTejr7rfXHwQ=
MIME-Version: 1.0
In-Reply-To: <4CC2FD0A.9090409@teksavvy.com>
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
	<4CC24186.1040001@teksavvy.com>
	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>
	<4CC2FD0A.9090409@teksavvy.com>
Date: Sat, 23 Oct 2010 16:20:47 +0100
Message-ID: <AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Interesting, as the badblocks program doesn't think these sectors are
bad. Can I test them any other way?

Thanks,

// Mathias

On 23 October 2010 16:19, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-10-23 08:57 AM, Mathias Burén wrote:
>>
>> Hi,
>>
>> Thanks for the clarification. Since I've (stupidly enough) partitioned
>> the drives from 1MB until the end, I'm most likely affected by this
>> stupid RAID BIOS.
>> That might explain why I'm getting this error (full dmesg at
>> http://pastebin.ca/1970873 ):
>>
>> ata2.00: status: { DRDY }
>> ata2: hard resetting link
>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata2.00: configured for UDMA/133
>> ata2.00: device reported invalid CHS sector 0
>> sd 1:0:0:0: [sdb]  Result: hostbyte=0x00 driverbyte=0x08
>> sd 1:0:0:0: [sdb]  Sense Key : 0xb [current] [descriptor]
>> Descriptor sense data with sense descriptors (in hex):
>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>         00 00 00 00
>> sd 1:0:0:0: [sdb]  ASC=0x0 ASCQ=0x0
>> sd 1:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 e7 70 c8 e8 00 05 40 00
>> end_request: I/O error, dev sdb, sector 3882928360
>> md/raid:md0: read error not correctable (sector 3882926312 on sdb1).
>> md/raid:md0: Disk failure on sdb1, disabling device.
>
>
> No, that error looks like a real disk media error -- bad sector(s) on the
> drive.
>
> The BIOS issue merely gives corrupted data, not read errors.
>
