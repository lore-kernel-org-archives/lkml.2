Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0CUK34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:29:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0CUK3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iUBj8UotUMAy93DM0vnsGLxLWhg9kPO/TPD10uR2Jm8u7TMPzwG9MzY8jT6Qzq56A8
         t+vmiOyQZd1JR6Ww1ZggP0um/hgAv5qFyKjAfGVeeCTy0wpgxWgcSVKwbbnQPN7ouRYi
         syjcJLDN7sTJ05jjvTPCeU4AlAzZD7r5ERDQE=
MIME-Version: 1.0
In-Reply-To: <4BA3C461.5060209@gmx.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
	 <4BA3C07A.8030204@gmx.net>
	 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
	 <4BA3C461.5060209@gmx.net>
Date: Sun, 21 Mar 2010 18:29:53 +0800
Message-ID: <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
Subject: Re: BUG:write data to degrade raid5
From: jin zhencheng <zhenchengjin@gmail.com>
To: Joachim Otahal <Jou@gmx.net>
Cc: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>,
       neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Joachim Otahal:

ths for your test on "Debian 2.6.26-21lenny4".
if you want to see the oop ,you should always write to the raid5 ,and
pull 2 disks out.maybe you can see the error

i think no matter what i do ,even if i pull out all the disk , kernel
should not oop.


On Sat, Mar 20, 2010 at 2:37 AM, Joachim Otahal <Jou@gmx.net> wrote:
> Kristleifur Daðason schrieb:
>>
>> On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net
>> <mailto:Jou@gmx.net>> wrote:
>>
>>    jin zhencheng schrieb:
>>
>>        hi;
>>
>>        i use kernel is 2.6.26.2
>>
>>        what i do as follow:
>>
>>        1, I create a raid5:
>>        mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
>>        --metadata=1.0 --assume-clean
>>
>>        2, dd if=/dev/zero of=/dev/md5 bs=1M&
>>
>>        write data to this raid5
>>
>>        3, mdadm --manage /dev/md5 -f /dev/sda
>>
>>        4 mdadm --manage  /dev/md5 -f /dev/sdb
>>
>>        if i faild 2 disks ,then the OS kernel display OOP error and
>>        kernel down
>>
>>        do somebody know why ?
>>
>>        Is MD/RAID5 bug ?
>>
>>
>>    RAID5 can only tolerate ONE drive to fail of ALL members. If you
>>    want to be able to fail two drives you will have to use RAID6 or
>>    RAID5 with one hot-spare (and give it time to rebuild before
>>    failing the second drive).
>>    PLEASE read the documentation on raid levels, like on wikipedia.
>>
>>
>> That is true,
>>
>> but should we get a kernel oops and crash if two RAID5 drives are failed?
>> (THAT part looks like a bug!)
>>
>> Jin, can you try a newer kernel, and a newer mdadm?
>>
>> -- Kristleifur
>
> You are probably right.
> My kernel version is "Debian 2.6.26-21lenny4", and I had no oopses during my
> hot-plug testing one the hardware I use md on. I think it may be the driver
> for his chips.
>
> Jin:
>
> Did you really use the whole drives for testing or loopback files or
> partitions on the drives? I never did my hot-plug testings with whole drives
> being in an array, only with partitions.
>
> Joachim Otahal
>
>
