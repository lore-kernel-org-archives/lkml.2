Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0DGMKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:10:06 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:62411 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab0DGMKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uy75dikf5keA0xwvZD2DwI+yc4YdpdeVDmGMcfQI7Ysig8YiE+MMg/YpnmshK+euFt
         2M4SE/UQIHHBJZQ4n5fnbYidIR4kBP1YLwasghmahWpnAZ0Du2zM/XHhNWSGz5v5iiD4
         UMOPddLIUsfCDBv7wmf78TrhCLfuI/dNurxtM=
MIME-Version: 1.0
In-Reply-To: <n2jacff6c2b1004062248w311d8482w6c64a7bdfded8385@mail.gmail.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <4BBB8F07.60401@zytor.com>
	 <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com>
	 <q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com>
	 <3715922601579231267@unknownmsgid> <4BBBC470.4050002@zytor.com>
	 <q2he6bf505b1004061847l31b2fe15v31d1556862d3a2f9@mail.gmail.com>
	 <n2uacff6c2b1004061904v5d290fa6v909e2e5fe32ff910@mail.gmail.com>
	 <4BBBE976.1000603@zytor.com>
	 <n2jacff6c2b1004062248w311d8482w6c64a7bdfded8385@mail.gmail.com>
Date: Wed, 7 Apr 2010 07:10:02 -0500
Message-ID: <m2me6bf505b1004070510q63926780uac2807ca0ab22db6@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Venkatram Tummala <venkatram867@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Youngwhan Song <breadncup@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 12:48 AM, Venkatram Tummala
<venkatram867@gmail.com> wrote:
> I completely agree with you. I was just trying to clarify Xianghua's
> statement "last 128 MB is used for HIGHMEM". I got the feeling that he
> thought that last 128MB can be used for vmalloc, IO and for HIGHMEM. So, i
> was clarifying that last 128MB is not "used for highmem" but it is used to
> support highmem.(among many other things). That was what i intended.
>
> On Tue, Apr 6, 2010 at 7:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> On 04/06/2010 07:04 PM, Venkatram Tummala wrote:
>> > Hey Xiao,
>> >
>> > last 128MB is not used for highmem. last 128MB is used for data
>> > structures(page tables etc.) to support highmem .  Highmem is not
>> > something which is "INSIDE" Kernel's Virtual Address space. Highmem
>> > refers to a region of "Physical memory" which can be mapped into
>> > kernel's virtual address space through page tables.
>> >
>> > Regards,
>> > Venkatram Tummala
>> >
>>
>> Not quite.
>>
>> The vmalloc region is for *anything which is dynamically mapped*, which
>> includes I/O, vmalloc, and HIGHMEM (kmap).
>>
>>        -hpa
>>
>> --
>> H. Peter Anvin, Intel Open Source Technology Center
>> I work for Intel.  I don't speak on their behalf.
>>
>
>

Thanks Venkatram, do these sound right:

1. All HIGHMEM(physical address beyond 896MB) are kmapped back into
the last 128MB kernel "virtual" address space(using page tables stored
in the last 128MB physical address). That also implies it's a very
limited virtual space for large memory system and need do kunmap when
you're done with it(so you can kmap other physical memories in).
I'm not familiar with large-memory systems, not sure how kmap cope
with that using this limited 128M window assuming kernel is 1:3 split.

2. The last 128MB physical address can be used for page tables(kmap),
vmalloc, IO,etc

Regards,
Xianghua
