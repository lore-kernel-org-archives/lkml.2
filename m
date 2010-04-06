Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0DFTU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:20:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62584 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0DFTUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qnPxqmr+fjfrBQt5NoUEJJzDdEwzZbEKRlFeGaf4skTpBIQoFb0qxyPbW9Zr2xo3PY
         bhoCLXDr2M5DK+tyfC41f0Jg4vkAcHMFN0VTUXtTX5Wdo8oFLEkklcvNhnbkVVLR/WeK
         /3C9ZBUb4FWjmNHBOSqz/Y1YWM/xLBnOBxcxc=
MIME-Version: 1.0
In-Reply-To: <4BBB7AC9.5060008@zytor.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	 <4BBB7AC9.5060008@zytor.com>
Date: Tue, 6 Apr 2010 12:20:22 -0700
Message-ID: <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Frank Hu <frank.hu.2001@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joel Fernandes <agnel.joel@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/06/2010 08:02 AM, Joel Fernandes wrote:
>> Hi Hayfeng,
>>
>> On Tue, Apr 6, 2010 at 8:07 PM, hayfeng Lee <teklife.kernel@gmail.com> wrote:
>>> hello,every one.
>>> I have a question:
>>> Why does linux choose 896MB to do a start point of ZONE_HIGHMEM and
>>> the end point of ZONE_NORMAL. Just for experience?
>>> What is the advantages?
>>
>> This is not an advantage but a limitation of 32 bit processor and
>> architecture. Only physical memory in first 896MB  is directly mapped
>> to the kernel virtual memory address space. This is called
>> ZONE_NORMAL. To access any physical memory in ZONE_HIGHMEM, the kernel
>> has to set up page table entries to indirectly map the physical memory
>> into a virtual memory address (I think around 128MB or so worth page
>> table entries are reused for this purpose). On the other hand, on 64
>> bit architectures, the entire physical memory is directly mapped and
>> accessible to the kernel. ZONE_HIGHMEM doesn't exist on 64 bit.
>>
>> Take the above with a grain of salt, someone with a better knowledge
>> about this intrusive topic can be give a more detailed explanation :)
>>
>
> The ELF ABI specifies that user space has 3 GB available to it.  That
> leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
> mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.
>
> All of these boundaries are configurable; with PAE enabled the user
> space boundary has to be on a 1 GB boundary.
>
>        -hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

the VM split is also configurable when building the kernel (for 32-bit
processors).
