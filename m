Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3AHRRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:17:20 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56553 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab3AHRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:17:19 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxXAMz5Sg44e-TJ0P=LY+3VkfdNtZMS3EJEHdztY2kC0Q@mail.gmail.com>
References: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
	<CA+55aFxXAMz5Sg44e-TJ0P=LY+3VkfdNtZMS3EJEHdztY2kC0Q@mail.gmail.com>
Date: Wed, 9 Jan 2013 01:17:16 +0800
Message-ID: <CAAJw_ZtpubRhSF3K=B91oHXMPaTX6jGNLZn+e6ks83JS92k=bw@mail.gmail.com>
Subject: Re: 2nd attempt: help with dma_alloc_coherent() + dma_free_coherent()
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 12:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jan 8, 2013 at 7:51 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> No response so far ... I'm sure someone know this stuff ...  Thanks, Jeff.
>>
>> I'm trying to understand how this oops in the diva driver and it's just a
>> simple dma_alloc_coherent() followed by dma_free_coherent(), but it oops.
>> Why?
>
> Umm. You're using a NULL 'dev' pointer?
>
> iommu_no_mapping() will look if the device is a PCI device, and that's
> where it oopses.
>
> Now, it looks like some users "know" that the device doesn't matter
> (which is true on some platforms), but that's bogus. The device is how
> you even find out what the rules for DMA access are (see for example
> dma_set_mask() etc), so giving a NULL device is insane.
>
>               Linus


Interesting, but there are 54 lines under the kernel directories that
use "dma_alloc_coherent(NULL," followed by "dma_free_coherent(NULL,"

So, shouldn't they be fixed as well? ... unless they are so old that
nobody cares anymore ...


# find . -exec grep -H "dma_alloc_coherent(NULL" {} \; | wc -l
54

#find . -exec grep -H "dma_free_coherent(NULL" {} \; | wc -l
72



Thanks,
Jeff
