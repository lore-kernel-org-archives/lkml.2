Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3AHQjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:39:48 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:47492 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab3AHQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:39:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
References: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Jan 2013 08:39:24 -0800
X-Google-Sender-Auth: 7TEL2O0Szey98dTM0DFD0JRu0Eg
Message-ID: <CA+55aFxXAMz5Sg44e-TJ0P=LY+3VkfdNtZMS3EJEHdztY2kC0Q@mail.gmail.com>
Subject: Re: 2nd attempt: help with dma_alloc_coherent() + dma_free_coherent()
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 7:51 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> No response so far ... I'm sure someone know this stuff ...  Thanks, Jeff.
>
> I'm trying to understand how this oops in the diva driver and it's just a
> simple dma_alloc_coherent() followed by dma_free_coherent(), but it oops.
> Why?

Umm. You're using a NULL 'dev' pointer?

iommu_no_mapping() will look if the device is a PCI device, and that's
where it oopses.

Now, it looks like some users "know" that the device doesn't matter
(which is true on some platforms), but that's bogus. The device is how
you even find out what the rules for DMA access are (see for example
dma_set_mask() etc), so giving a NULL device is insane.

              Linus
