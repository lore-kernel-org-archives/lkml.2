Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2GFFUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:20:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34377 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2GFFUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:20:54 -0400
Message-ID: <4FF6759A.3010901@in.ibm.com>
Date: Fri, 06 Jul 2012 10:50:26 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.4.0-rc1: No init found
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org> <1333440522.3040.9.camel@pasglop> <alpine.DEB.2.01.1204030953320.4930@trent.utfs.org> <4F7C4058.6090405@in.ibm.com> <CAOZdJXVhtxoiY0kvsC+zgrETgd_MxTR+nf+6JDMV5Y-osqVqaw@mail.gmail.com>
In-Reply-To: <CAOZdJXVhtxoiY0kvsC+zgrETgd_MxTR+nf+6JDMV5Y-osqVqaw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070605-9574-0000-0000-000003767AC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 04:06 AM, Tabi Timur-B04825 wrote:
> On Wed, Apr 4, 2012 at 7:36 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
>
>>> Not sure if this is related, but at the end of each kernel compilation,
>>> the following messages are printed:
>>>
>>> ------------
>>>     SYSMAP  System.map
>>>     SYSMAP  .tmp_System.map
>>>     WRAP    arch/powerpc/boot/zImage.pmac
>>> INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the
>>> wrapper(0x400000)
>>> INFO: Fixing the link_address of wrapper to (0x700000)
>>>     WRAP    arch/powerpc/boot/zImage.coff
>>> INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the
>>> wrapper(0x500000)
>>> INFO: Fixing the link_address of wrapper to (0x700000)
>>>     WRAP    arch/powerpc/boot/zImage.miboot
>>> INFO: Uncompressed kernel (size 0x6d4b80) overlaps the address of the
>>> wrapper(0x400000)
>>> INFO: Fixing the link_address of wrapper to (0x700000)
>>>     Building modules, stage 2.
>>>     MODPOST 24 modules
>>> ------------
>>>
>>> I started to see these messages in January (around Linux 3.2.0), but never
>>> investigated what it was since the produced kernels continued to boot just
>>> fine.
>>
>>
>> The above change was added by me. The message is printed when the 'wrapper'
>> script finds that decompressed kernel overlaps the 'bootstrap code' which
>> does the decompression. So it shifts the 'address' of the bootstrap code to
>> the next higher MB. As such it is harmless.
>
> I see this message every time when I build the kernel.  I know it's
> harmless, but is this something that can be "fixed"?  That is, can we
> change some linker script (or whatever) to make 0x700000 the default
> value?

You could do this by setting the link_address by checking your platform,
like some of the other platforms (e.g, pseries, ps3 ).

Or

we could add a parameter to the wrapper script to set the link_address ?

Ben, Josh,
What do you think ?

  Or maybe modify the wrapper script to just automatically find
> the right spot without printing a message?

We need the message there for people who have restriction of a fixed 
link address. This would help them to handle the situation accordingly
than blindly failing on boot.

Thanks
Suzuki

