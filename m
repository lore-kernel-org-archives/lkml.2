Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1CPFTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:19:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59837 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1CPFTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VDbnDHNMIYXJADmKGsIyp/WmlBczfLGy/IJooWBUZGScO45j4TqOwLD+68UxShOFu1
         LULPe/iXUzOjxnuPUc0tSKVixgMfdPW2UlKL0PdPkEHO6Va/UpGTU3DRex5tT0S/E/LS
         zfOr1/yYA/hbCX8TWbsdOxKDKTo/ZILrxDqz0=
MIME-Version: 1.0
In-Reply-To: <20110315091412.de6eb63c.rdunlap@xenotime.net>
References: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com> <20110315091412.de6eb63c.rdunlap@xenotime.net>
From: Aneesh Bhasin <contact.aneesh@gmail.com>
Date: Wed, 16 Mar 2011 10:49:04 +0530
Message-ID: <AANLkTikU_kPOoNv6gJiPOsmrkFDddTLQ-0--wViYyFxj@mail.gmail.com>
Subject: Re: smap output - unnamed entries and heap
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-newbie <linux-newbie@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 9:44 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 15 Mar 2011 14:31:50 +0530 Aneesh Bhasin wrote:
>
>> Hi All,
>>
>> My apologies if this is not the right place for these type of
>> questions - I do not know of a better place to ask this.
>>
>> I am trying to take out some memory figures from the /proc/<pid>/smaps
>> interface (linux v2.6.35). However, I could not find what do the
>> entries that have no name associated to them (no library path or
>> binary path with these entries) mean. So, I wrote a test C program
>> that allocates 100MB of memory (using malloc) and then writes to it in
>> chunks of 10MB. I could see that the 'Size' and 'RSS' of one of the
>> unnamed entries was increasing in accordance with the code, but there
>> were several other such unnamed sections too - is there a way to know
>> what and where do they come from.
>>
>> Also, I could see that for some process the smap interface was showing
>> a '[heap]' entry but not for all - e.g. for my above test case, there
>> was no '[heap]' entry, although I assumed the malloc should have
>> reflected in the [heap]. Can someone please tell me (or point me in
>> the right direction) why is heap entry there only for some processes ?
>>
>> Thanks in advance for any help..
>
> Did you look at Documentation/filesystems/proc.txt ?
> It has some info on smaps and maps.
>
> ---
> ~Randy

Thanks for the pointer Randy. I had a look at it and here is my
understanding regarding this (please correct me if I am wrong)

The entries in smaps (or maps) that have no name associated with them
are anonymous memory regions. malloc, e.g. could allocate a memory
using anonymous mmap for large blocks of memory due to efficiency
reason. Are there any other such sources/reasons for creating
anonymous memory regions ?
I checked some of the above, by modifying my test program to allocate
1KB memory - this time it was attributed to [heap] whereas a memory
allocation of 1MB was attributed to one of the anonymous memory
regions.
So, does that mean that all anonymous regions can be treated
effectively as heap ? Also, is there a way in linux (without using
dedicated tools like valgrind), to see how much heap or anonymous
memory is attributed to code arising from a particular library/binary
?

Thanks for the help !

Regards,
Aneesh Bhasin
