Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab1HEJNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:13:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35324 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab1HEJNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110805084614.GA1588@x4.trippels.de>
References: <20110805010038.GA18148@redhat.com>
	<20110805084614.GA1588@x4.trippels.de>
Date: Fri, 5 Aug 2011 12:13:06 +0300
X-Google-Sender-Auth: tNjOkfz6SHc93GzWK6A4BLfpah8
Message-ID: <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 11:46 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2011.08.04 at 21:00 -0400, Dave Jones wrote:
>> Sometime in the last week, something was merged which causes my laptop
>> to lock up occasionally.  I can trigger it most of the time just by
>> doing a kernel build. When it gets to the final linking stage, it locks up hard.
>>
>> I finally managed to coax something out of usb console to get the traces below,
>> which seem to implicate something in the block layer ?
>>
>> my root device is an lvm volume on an dmcrypt'd block dev, which might be relevant,
>> as I don't see this happening on other machines with simpler setups.
>>
>> I'm going to try bisecting, but it might take me a few days, because it's
>> such a pain in the ass to reproduce this reliably.
>>
>> [ 5913.233035] ------------[ cut here ]------------
>> [ 5913.233097] WARNING: at lib/list_debug.c:53 __list_del_entry+0x8d/0x98()
>> [ 5913.233101] Hardware name: Adamo 13
>> [ 5913.233105] list_del corruption. prev->next should be ffffea000434fd20, but was ffffea0004199520
>
> See also: http://lkml.org/lkml/2011/8/3/37

That's in networking so SLUB lockless patches are almost certainly the
issue here. Is this with SLUB debugging enabled or not? Christoph, it
like the partial lists are getting corrupted somehow.

                                Pekka
