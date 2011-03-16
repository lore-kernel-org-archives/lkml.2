Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1CPBXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:23:52 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:45464 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1CPBXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:23:49 -0400
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        warns@pre-sense.de
Message-Id: <E0782A6F-B851-4A11-B740-446EF7941B7C@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Alpha no longer recognises certain partition tables (v2.6.38)
Date: Wed, 16 Mar 2011 14:23:43 +1300
References: <4D7F2C11.907@orcon.net.nz> <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx6.orcon.net.nz on Wed, 16 Mar 2011 14:23:45 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Mar 16 14:23:45 2011
X-DSPAM-Confidence: 0.7007
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/2011, at 4:10 AM, Linus Torvalds wrote:
> On Tue, Mar 15, 2011 at 2:06 AM, Michael Cree <mcree@orcon.net.nz>  
> wrote:
>> v2.6.38 boot reports it can't recognise the partition table on the  
>> system
>> disk on my Alpha and panics when it can't find the root device.
>>
>> It worked at v2.6.38-rc7.
>>
>> While I haven't done a bisect to fully verify I nevertheless  
>> suggest the
>> following patch as the likely cause:
>>
>> 1eafbfe Fix corrupted OSF partition table parsing
>
> That sounds likely. What does something like the attached do? In
> particular, what's the printed-out value of the OSF npartitions thing?
>
> Also, it's quite possible that we should raise the value of
> MAX_OSF_PARTITIONS. If I checked it right, the d_partitions[] array
> starts at byte offset 148 in the sector, and it's 16 bytes in size, so
> there _could_ be up to 22 partitions there. The fact that we had
> defined the 'struct disklabel' to only contain 8 partitions is I think
> from documentation, not a technical "there can be only eight".

I am not able to run the patch until much later today but I think the  
number of partitions is the issue.  I have three disks, all with bsd  
type partition tables, and the kernel sees the partition tables of two  
of them (they both have fewer than five partitions) but the system  
disk has about nine (or it might be ten) partitions.  I didn't know  
the limit when creating them some time ago and assumed fdisk would  
flag an error if the number of permitted partitions was exceeded!   
What's more it worked with recent kernels until now.

I'll give the patch a whirl later (my) today.

Cheers
Michael.

