Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1JaJR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:17:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1JaJRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <20111031074836.GB4910@ubuntu.corp.ad>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	<20111031074836.GB4910@ubuntu.corp.ad>
Date: Mon, 31 Oct 2011 14:47:54 +0530
Message-ID: <CAJw04pAxDrKHieQGbQRc2L9wyisZKTyW7SnDdNWBRYV4ptwuAg@mail.gmail.com>
Subject: Re: powerpc 476, Little-endian, pte fault
From: Santosh Kumar <santoshkumar.a@gmail.com>
To: Shan Hai <haishan.bai@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i tried this but the fixup_user_fault is called as the path followed
is different. Also i see that the flags passed to handle_mm_fault is 0
i.e the fault is not on a write access. Please let me know if i have
to use this fix some where else too.

thanks
Santosh Kumar .A

Vision without Action is a daydream... Action without Vision is a nightmare...



On 31 October 2011 13:18, Shan Hai <haishan.bai@gmail.com> wrote:
> On Mon, Oct 31, 2011 at 11:00:14AM +0530, Santosh Kumar wrote:
>> KERNEL: linux 2.6.39.4
>> POWERPC: 476, little endian.
>>
>> I am trying to get linux 2.6.39.4 up on PPC 476 i have done done
>> Big-endian to little endian Changes in:
>> 1) bitops header file.
>> 2) while reading the device tree.
>> 3) the PTE read/computed in head_32.S
>> 4) added E bit in the TLB entries.
>>
>> with all the above changes the kernel_init is done but and inited is mounted.
>>
>> But while spawning init process the kernel continuously hits pte
>> faults at address 0x100000fc and never comes out. Please let me know
>> where i should be looking into.
>>
>
> Please check whether the following commit is there in your tree.
> 2efaca927f5cd7ecd0f1554b8f9b6a9a2c329c03
>
> Cheers
> Shan Hai
>
>> -
>> Thanks
>> Santosh Kumar .A
>>
>> Vision without Action is a daydream... Action without Vision is a nightmare...
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
