Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0CSS0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:26:41 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50100 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0CSS0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=SgibSgMlmGrqjvOkuEdof7xoU2OJUBUCpNpJe6WG2TbbZPJ8CscgHCX9JhTgTrqmmf
         IoX1P+zc4IDXDU2itis/iO4LYlZYgD7LNsQfIhPlAurkDawEmBldunP0WzQpiUNdk1xH
         Pc1UhU5eoQRvNrn9AyyRmkXJalOt/M719JHR4=
MIME-Version: 1.0
In-Reply-To: <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com> 
	<4BA3C07A.8030204@gmx.net> <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Date: Fri, 19 Mar 2010 18:26:18 +0000
Message-ID: <73e903671003191126l6c0bed69q69c32bf37922690d@mail.gmail.com>
Subject: Re: BUG:write data to degrade raid5
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 6:20 PM, Joachim Otahal <Jou@gmx.net> wrote:
> jin zhencheng schrieb:
>>
>> hi;
>>
>> i use kernel is 2.6.26.2
>>
>> what i do as follow:
>>
>> 1, I create a raid5:
>> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
>> --metadata=1.0 --assume-clean
>>
>> 2, dd if=/dev/zero of=/dev/md5 bs=1M&
>>
>> write data to this raid5
>>
>> 3, mdadm --manage /dev/md5 -f /dev/sda
>>
>> 4 mdadm --manage  /dev/md5 -f /dev/sdb
>>
>> if i faild 2 disks ,then the OS kernel display OOP error and kernel down
>>
>> do somebody know why ?
>>
>> Is MD/RAID5 bug ?
>>
>
> RAID5 can only tolerate ONE drive to fail of ALL members. If you want to be
> able to fail two drives you will have to use RAID6 or RAID5 with one
> hot-spare (and give it time to rebuild before failing the second drive).
> PLEASE read the documentation on raid levels, like on wikipedia.
>

That is true,

but should we get a kernel oops and crash if two RAID5 drives are
failed? (THAT part looks like a bug!)

Jin, can you try a newer kernel, and a newer mdadm?

-- Kristleifur
