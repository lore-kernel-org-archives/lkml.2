Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2LCWco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 17:32:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61044 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2LCWcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 17:32:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLv9SxeW2sbOoQxeNHbwrpqXnpFjJoHgQAk7VyfbCpn4g@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
	<874nk2u69u.fsf@silenus.orebokech.com>
	<CA+8MBbLv9SxeW2sbOoQxeNHbwrpqXnpFjJoHgQAk7VyfbCpn4g@mail.gmail.com>
Date: Mon, 3 Dec 2012 14:32:42 -0800
X-Google-Sender-Auth: z75f4JTv_uMKkmaxwsUZkvYgLHo
Message-ID: <CA+8MBbLCnXSuuWXAJCi4eSYXKj6bci7KT+brM2TbrnCHquGXVQ@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
From: Tony Luck <tony.luck@intel.com>
To: Romain Francoise <romain@orebokech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 2:29 PM, Tony Luck <tony.luck@intel.com> wrote:
>
>
>
> On Mon, Dec 3, 2012 at 2:20 PM, Romain Francoise <romain@orebokech.com>
> wrote:
>>
>> Hi Linus,
>>
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>> > Linus Torvalds (5):
>> >       fs/buffer.c: make block-size be per-page and protected by the
>> > page lock
>> >       blockdev: remove bd_block_size_semaphore again
>> >       direct-io: don't read inode->i_blkbits multiple times
>> >       blkdev_max_block: make private to fs/buffer.c
>>
>> Could these changes be the reason for the following suddenly appearing in
>> one of my VMs with rc8 (no such messages with rc7)? Pretty standard
>> virtio
>> setup in KVM.
>>
>> [   11.832295] attempt to access beyond end of device
>> [   11.832298] vda1: rw=0, want=4192904, limit=4192902
>> [   11.832299] Buffer I/O error on device vda1, logical block 524112
>> [   11.832394] attempt to access beyond end of device
>> [   11.832395] vda1: rw=0, want=4192904, limit=4192902
>> [   11.832396] Buffer I/O error on device vda1, logical block 524112
>>
> I'm seeing similar stuff in -rc8 too (on ia64, native no VMM):
>
>
> attempt to access beyond end of device
> sda3: rw=0, want=268317424, limit=268317421
> Buffer I/O error on device sda3, logical block 33539677
>
> attempt to access beyond end of device
> sda3: rw=0, want=268317424, limit=268317421
> Buffer I/O error on device sda3, logical block 33539677
>
> -rc7 didn't do this.
>
> -Tony

Resend ... to go to the list (Oh gmail, why did you decide to reply in HTML???)
