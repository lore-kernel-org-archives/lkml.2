Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0HKSmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:42:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36825 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0HKSmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=feOBZlkzNU0PLcOE3a7BjnSr0zP5y34+9hdjq5403IIAqBZxOvPccP2Wo27ADtg2Jz
         DqfXfL+qn+JRnkNWmJ6nx1oSodW/TTsc3CLVSBcOj9PiKtGPnM/+aadwG9I4v2Kxan0I
         MzUWHWyPNQSg8llFpkQ7MqY+9D4VVHc0ZglMg=
MIME-Version: 1.0
In-Reply-To: <20100810001244.GD2569@local>
References: <AANLkTimWdaBrJz-dQ3MHWwG7iZ5m1opSmLFKva880csi@mail.gmail.com>
	<20100809111155.GB2569@local>
	<20100810001244.GD2569@local>
Date: Wed, 11 Aug 2010 20:42:35 +0200
Message-ID: <AANLkTingmHe9z6KLp_euogxbXCTCZN+DMs2oEpC6VDKn@mail.gmail.com>
Subject: Re: UIO DMA to userspace question
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Tom Lyon <pugs@cisco.com>, mst@redhat.com, gregkh@suse.de,
        chrisw@sous-sol.org, joro@8bytes.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

On Tue, Aug 10, 2010 at 2:12 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Mon, Aug 09, 2010 at 01:11:56PM +0200, Hans J. Koch wrote:
>> On Sat, Aug 07, 2010 at 08:38:30PM +0200, Leon Woestenberg wrote:
>> > Hello all,
>> >
>> > can I use the UIO framework for the following?
>> >
>> > The userspace portion of the driver allocates memory in user-space
>> > using malloc() - usually resulting in a scatter pages in physical
>> > memory.
>> > The UIO kernel portion of the driver maps those using pci_map_sg().
>> >
>> > Is this possible, or does the UIO framework assume memory for DMA is
>> > allocated in kernel space?
>>
>> You would have to write your own mmap() function and and set the pointer
>> to it in struct uio_info->mmap. Have a look at uio_mmap() in
>
Why would I need to mmap() the user space memory into kernel space?

Looking from a traditional device driver perspective the kernel space
only needs to know the virtual address and the length of the buffer,
and can then make up a scatter list.

After DMA finished, it needs to synchronize caches.

In fact, from my simplistic view, the kernel provides a few internal
house keeping tools, and we need to export this functionality into UIO
API's.

SGDMA to from user memory would be one of the uses.

In fact, when UIO started, I also expected the kernel buffers to be
user application managed, like the driver steering code.

> uio_info->mmap pointer was made for unusual mappings. But it still causes
> me some headaches. I'm not sure if this can be considered a clean solution.
> An extension that makes UIO deal properly with dynamically allocated (DMA-)
> memory would certainly be preferable.
>
Thanks for thinking along.

I am currently refraining from using UIO, as I don't like the head
ache feature :-)

Regards,
-- 
Leon
