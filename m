Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0DGEVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 00:21:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:3251 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0DGEVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 00:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=jr7XaDag4gIwJxaZuad4/83qKlG/Ad2cz66jJQxWOyjAmgxN/VsZpGRGsWUjeoR785
         pKO6yZm3GoSJ3eY77zT9gSA69g/mIhpaTZ3LLna8ZcaznPvZTG/h9W0CdAlZ9efg03he
         DijuYGzvkqw30aGsPKAS6UoAGhfFwWaCehaT0=
Date: Wed, 7 Apr 2010 12:24:45 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] add random binaries to .gitignore
Message-ID: <20100407042445.GB3830@cr0.nay.redhat.com>
References: <4BAF4DAF.70609@gmail.com>
 <20100328133500.GB3622@core2>
 <4BAF5BD7.1060208@gmail.com>
 <20100328141957.GA3689@core2>
 <4BAF618E.2010604@gmail.com>
 <q2s9c2470ce1004062111hba0a067dwa9705a26d31b47f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <q2s9c2470ce1004062111hba0a067dwa9705a26d31b47f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 06:11:18AM +0200, Jan III Sobieski wrote:
>2010/3/28 Jan III Sobieski <jan3sobi3ski@gmail.com>:
>> W dniu 2010-03-28 16:19, Alexey Dobriyan pisze:
>>> On Sun, Mar 28, 2010 at 03:38:31PM +0200, Jan III Sobieski wrote:
>>>> W dniu 2010-03-28 15:35, Alexey Dobriyan pisze:
>>>>> On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
>>>>>> +# random binary files
>>>>>> +Documentation/filesystems/dnotify_test
>>>>>> +Documentation/laptops/dslm
>>>>>> +Documentation/timers/hpet_example
>>>>>> +Documentation/vm/hugepage-mmap
>>>>>> +Documentation/vm/hugepage-shm
>>>>>> +Documentation/vm/map_hugetlb
>>>>>> +arch/x86/boot/compressed/vmlinux
>>>>>> +arch/x86/tools/test_get_len
>>>>>
>>>>> This should go to per-directory gitiignores.
>>>>
>>>> I agree that it is not the best solution. But one directory one
>>>> .gitignore also isn't the best, so I propose this
>>>
>>> .gitignore in leaf directory is the status quo.
>>>
>>>       find . -type f -name '\.gitignore'
>>
>> Ok
>
>Anyone out there care to take this patches?

I think you need to Cc kbuild people. (Done.)

This patch looks fine for me, we need this, especially
the x86 piece, I met it several times.

Thanks!

>
>>
>> --
>> Jan III Sobieski
>>
>> Signed-off-by: Jan III Sobieski <jan3sobi3ski@gmail.com>
>>
>> diff --git a/Documentation/filesystems/.gitignore
>> b/Documentation/filesystems/.gitignore
>> new file mode 100644
>> index 0000000..1ddd62a
>> --- /dev/null
>> +++ b/Documentation/filesystems/.gitignore
>> @@ -0,0 +1,2 @@
>> +dnotify_test
>> +
>> diff --git a/Documentation/laptops/.gitignore
>> b/Documentation/laptops/.gitignore
>> new file mode 100644
>> index 0000000..f6bb9d0
>> --- /dev/null
>> +++ b/Documentation/laptops/.gitignore
>> @@ -0,0 +1,2 @@
>> +dslm
>> +
>> diff --git a/Documentation/timers/.gitignore
>> b/Documentation/timers/.gitignore
>> new file mode 100644
>> index 0000000..f710cba
>> --- /dev/null
>> +++ b/Documentation/timers/.gitignore
>> @@ -0,0 +1,2 @@
>> +hpet_example
>> +
>> diff --git a/Documentation/vm/.gitignore b/Documentation/vm/.gitignore
>> index 09b164a..3c65a46 100644
>> --- a/Documentation/vm/.gitignore
>> +++ b/Documentation/vm/.gitignore
>> @@ -1,2 +1,6 @@
>>  page-types
>>  slabinfo
>> +hugepage-mmap
>> +hugepage-shm
>> +map_hugetlb
>> +
>> diff --git a/arch/x86/boot/compressed/.gitignore
>> b/arch/x86/boot/compressed/.gitignore
>> index 4a46fab..b71c8ca 100644
>> --- a/arch/x86/boot/compressed/.gitignore
>> +++ b/arch/x86/boot/compressed/.gitignore
>> @@ -1,4 +1,5 @@
>>  relocs
>> +vmlinux
>>  vmlinux.bin.all
>>  vmlinux.relocs
>>  vmlinux.lds
>> diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
>> new file mode 100644
>> index 0000000..b1ac2dc
>> --- /dev/null
>> +++ b/arch/x86/tools/.gitignore
>> @@ -0,0 +1,2 @@
>> +test_get_len
>> +
>>
>
>
>
>-- 
>Jan III Sobieski
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
