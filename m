Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0FIChR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 22:37:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36754 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0FIChP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 22:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ASTeBKLz2oLK3SLP+b02CBv5TLfCJKtnYRDFcKPzwNSFvX0gS6TREAxG5rI8SBCD0G
         0Pl7Q8zR5HaP9PZf5RswqO6rjPXfTIohsCED/oEOp7weFq0Eks9r4W6R6Ng80v0CjYbX
         MqcNJ69UtVR4KeNYdrmKpix/BSrJO3je5ourw=
MIME-Version: 1.0
In-Reply-To: <1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	<1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
Date: Wed, 9 Jun 2010 10:37:13 +0800
Message-ID: <AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
From: Dave Young <hidave.darkstar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 12:43 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, 2010-06-07 at 11:00 +0100, Dave Young wrote:
>> On Mon, Jun 7, 2010 at 5:19 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > On Mon, 2010-06-07 at 06:20 +0100, Dave Young wrote:
>> >> On Fri, Jun 4, 2010 at 9:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> >> > On Fri, Jun 4, 2010 at 6:50 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> >> >> Dave Young <hidave.darkstar@gmail.com> wrote:
>> >> >>> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks
>> >> >>
>> >> >> Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
>> >> >> hasn't been reviewed yet (I'll probably need to repost, so if it fixes
>> >> >> the problem for you a Tested-by would be nice):
>> >> >>
>> >> >> http://lkml.org/lkml/2010/5/4/175
>> >> >
>> >> >
>> >> > I'd like to test, but I can not access the test pc during weekend. So
>> >> > I will test it next monday.
>> >>
>> >> Bad news, the patch does not fix this issue.
>> >
>> > Thanks for trying. Could you please just disable CONFIG_NO_BOOTMEM and
>> > post the kmemleak reported leaks again?
>>
>> Still too many suspected leaks, results similar with
>> (CONFIG_NO_BOOTMEM = y && apply your patch), looks like a little
>> different from original ones? I just copy some of them here:
>>
>> unreferenced object 0xde3c7420 (size 44):
>>   comm "bash", pid 1631, jiffies 4294897023 (age 223.573s)
>>   hex dump (first 32 bytes):
>>     05 05 00 00 ad 4e ad de ff ff ff ff ff ff ff ff  .....N..........
>>     98 42 d9 c1 00 00 00 00 50 fe 63 c1 10 32 8f dd  .B......P.c..2..
>>   backtrace:
>>     [<c1498ad2>] kmemleak_alloc+0x4a/0x83
>>     [<c10c1ace>] kmem_cache_alloc+0xde/0x12a
>>     [<c10b421b>] anon_vma_fork+0x31/0x88
>>     [<c102c71d>] dup_mm+0x1d3/0x38f
>>     [<c102d20d>] copy_process+0x8ce/0xf39
>>     [<c102d990>] do_fork+0x118/0x295
>>     [<c1007fe0>] sys_clone+0x1f/0x24
>>     [<c10029b1>] ptregs_clone+0x15/0x24
>>     [<ffffffff>] 0xffffffff
>
> I'll try to test the mmotm kernel as well. I don't get any kmemleak
> reports with the 2.6.35-rc1 kernel.

Manually bisected mm patches, the memleak caused by following patch:

mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

cc Rik van Riel

>
> Can you send me your .config file? Do you have CONFIG_HUGETLBFS enabled?
>
> Thanks.
>
> --
> Catalin
>
>



-- 
Regards
dave
