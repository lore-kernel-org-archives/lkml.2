Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab0JXMwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 08:52:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53088 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab0JXMwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 08:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tahjQg9bTxoWXGaSm8PNk++ogePeoywkI00OhQHi9ijBp82p1CTytbdUhkAzLzv5SO
         QPTEoCHvOq5jayOjCYFi5v4RuH2vO1PuMb4Urtj0EodEyldnWEL747njCIF9kF+YSKNi
         l2JIC3i7QOgtt4JfrP3nymCNFf1IqHbVAs0no=
MIME-Version: 1.0
In-Reply-To: <AANLkTin9wiBZjkeKxYKnJaSA1vxs8ELGTWYVMM1DfYKu@mail.gmail.com>
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
	<4CC24186.1040001@teksavvy.com>
	<AANLkTi=s9R-OEJAPRpoxoSkFY8MWhc22Pn_gcwCzxY=H@mail.gmail.com>
	<4CC2FD0A.9090409@teksavvy.com>
	<AANLkTin3QRgV5P4=BsTCeWhynGYMi3pd7BXrFpBXkWvj@mail.gmail.com>
	<4CC303FD.1000802@teksavvy.com>
	<AANLkTin9wiBZjkeKxYKnJaSA1vxs8ELGTWYVMM1DfYKu@mail.gmail.com>
Date: Sun, 24 Oct 2010 13:52:22 +0100
Message-ID: <AANLkTikzPgq0VG1V_hZsw78i2pYMxzrPJM3dFUyGeaU1@mail.gmail.com>
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2010 17:08, Mathias Burén <mathias.buren@gmail.com> wrote:
> Good! (that it's not a media error) I've ran extended SMART tests on
> the drive as well, and everything seemed fine.
>
> I'm going to try with 2.6.35 series now, see if I can salvage some data.
>
> Thanks,
>
> // Mathias
>
> On 23 October 2010 16:49, Mark Lord <kernel@teksavvy.com> wrote:
>> On 10-10-23 11:20 AM, Mathias Burén wrote:
>>>
>>> Hi,
>>>
>>> Interesting, as the badblocks program doesn't think these sectors are
>>> bad. Can I test them any other way?
>>
>> ..
>>>
>>> On 23 October 2010 16:19, Mark Lord<kernel@teksavvy.com>  wrote:
>>>>
>>>> On 10-10-23 08:57 AM, Mathias Burén wrote:
>>
>> ..
>>>>>
>>>>> ata2.00: status: { DRDY }
>>>>> ata2: hard resetting link
>>>>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>>> ata2.00: configured for UDMA/133
>>>>> ata2.00: device reported invalid CHS sector 0
>>>>> sd 1:0:0:0: [sdb]  Result: hostbyte=0x00 driverbyte=0x08
>>>>> sd 1:0:0:0: [sdb]  Sense Key : 0xb [current] [descriptor]
>>>>> Descriptor sense data with sense descriptors (in hex):
>>>>>         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
>>>>>         00 00 00 00
>>>>> sd 1:0:0:0: [sdb]  ASC=0x0 ASCQ=0x0
>>>>> sd 1:0:0:0: [sdb] CDB: cdb[0]=0x28: 28 00 e7 70 c8 e8 00 05 40 00
>>>>> end_request: I/O error, dev sdb, sector 3882928360
>>>>> md/raid:md0: read error not correctable (sector 3882926312 on sdb1).
>>>>> md/raid:md0: Disk failure on sdb1, disabling device.
>>>>
>>>>
>>>> No, that error looks like a real disk media error -- bad sector(s) on the
>>>> drive.
>>>>
>>>> The BIOS issue merely gives corrupted data, not read errors.
>>
>> MMm.. you're right.
>> I just now looked at the full dmesg you posted,
>> and those are NOT media errors.
>>
>> It looks like NCQ commands are behaving strangely for some reason
>> in your 2.6.36 kernel.
>>
>> Can you retest with, say, 2.6.34 ?
>> There were a number of sata_mv updates in between,
>> and I'm wondering if perhaps one of them broke something?
>>
>> Or if you just want to stabilize things, then turn off NCQ.
>>
>> Cheers
>>
>

Hey again,

Wow, somehow it looks like it's actually OK now. I don't know why to
be honest. Details:

[root@ion raid-MBR-backup]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdg1[0] sdc1[3] sdd1[4] sdb1[1]
      5851054080 blocks super 1.2 level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

So it successfully grew to 4 devices. Yay! It's online and happy. The
~3.7TB ext4 fs under the LVM beneath md0 is fine.

What I need to do now, is shrink each partition of the 4 drives making
the RAID, to avoid the last 2 GB.

What I've done is, I shrinked md0 with mdadm --grow, so now it looks
like this on one of the drives:

[root@ion raid-MBR-backup]# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
           Name : ion:0  (local to host ion)
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 11702108160 (5580.00 GiB 5991.48 GB)
  Used Dev Size : 3900702720 (1860.00 GiB 1997.16 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 634f3893:7af5fdd3:7ff344c7:8e3c4cff

    Update Time : Sun Oct 24 14:31:00 2010
       Checksum : 1a7657ec - correct
         Events : 30786

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)

My question is, is it safe for me to stop md0, delete all 4 partitions
that make up md0, recreate them at the same starting sector, but
ending 2GB from the last sector? Is this safe, will I lose any data?
Just in case I've backuped the MBR (first 512 bytes) of each HDD that
has the partition.

(sorry for top posting..)

Kind regards,
// Mathias
