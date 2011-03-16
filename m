Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1CPHkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:40:21 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:58447 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1CPHkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 03:40:15 -0400
Message-ID: <4D80695D.8080903@orcon.net.nz>
Date: Wed, 16 Mar 2011 20:40:13 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        warns@pre-sense.de
Subject: Re: Alpha no longer recognises certain partition tables (v2.6.38)
References: <4D7F2C11.907@orcon.net.nz> <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com> <AANLkTi=yev46gYosVdSfVvmf7MnB2oVriyvDT+pu1FnC@mail.gmail.com>
In-Reply-To: <AANLkTi=yev46gYosVdSfVvmf7MnB2oVriyvDT+pu1FnC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx1.orcon.net.nz on Wed, 16 Mar 2011 20:40:13 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 16 20:40:14 2011
X-DSPAM-Confidence: 0.5944
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/11 05:17, Linus Torvalds wrote:
> On Tue, Mar 15, 2011 at 8:10 AM, Linus Torvalds <torvalds@linux-foundation.org>  wrote:
>>
>> Also, it's quite possible that we should raise the value of
>> MAX_OSF_PARTITIONS. If I checked it right, the d_partitions[] array
>> starts at byte offset 148 in the sector, and it's 16 bytes in size, so
>> there _could_ be up to 22 partitions there.
>
> Actually, I think it's byte offset 148 in the structure, but the
> structure is at offset 64 in the partition sector, so I think that
> leaves room for just 18 partitions in one 512-byte sector.
>
> Of course, we do end up reading a whole page, so historically we've
> been able to see even more when the sector is aligned right (and it
> is, it's the first sector). So by mistake we could have accepted many
> more partitions and it just "worked" because we never actually checked
> any limits.

OK, I've fallen for that and created too many partitions on my system 
disk.  When using your patch dmesg reports:

[    7.511714] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: 
(1.50 TB/1.36 TiB)
[    7.551753] sd 1:0:0:0: [sdb] Write Protect is off
[    7.572261] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.591792] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    7.633785] OSF: 10 partitions
[    7.654292]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
[    7.675777] sd 1:0:0:0: [sdb] Attached SCSI disk

I could get it back to eight partitions but it will require copying the 
largest partition to another disk and back again as that partition does 
not meet the conditions for resizing.  Part of the reason for so many 
partitions was a brilliant scheme (or so it seemed at the time) when I 
repartitioned the disk in a manner that enabled me to do an efficient 
"in-place" repartitioning of an already well used disk.

Cheers
Michael.
