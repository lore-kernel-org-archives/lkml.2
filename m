Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2KFDNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 22:13:22 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55123 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KFDNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 22:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121105.202501.1246122770431623794.davem@davemloft.net>
References: <1352155633-8648-1-git-send-email-walken@google.com>
	<1352155633-8648-16-git-send-email-walken@google.com>
	<20121105.202501.1246122770431623794.davem@davemloft.net>
Date: Mon, 5 Nov 2012 19:13:19 -0800
Message-ID: <CANN689Gt2mG8xfkVkFtOHDFxkoZZAL-p-8yMSw=qvy5zaGs1ag@mail.gmail.com>
Subject: Re: [PATCH 15/16] mm: use vm_unmapped_area() on sparc32 architecture
From: Michel Lespinasse <walken@google.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, riel@redhat.com, hughd@google.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, lethal@linux-sh.org, cmetcalf@tilera.com,
        x86@kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 5:25 PM, David Miller <davem@davemloft.net> wrote:
> From: Michel Lespinasse <walken@google.com>
> Date: Mon,  5 Nov 2012 14:47:12 -0800
>
>> Update the sparc32 arch_get_unmapped_area function to make use of
>> vm_unmapped_area() instead of implementing a brute force search.
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> Hmmm...
>
>> -     if (flags & MAP_SHARED)
>> -             addr = COLOUR_ALIGN(addr);
>> -     else
>> -             addr = PAGE_ALIGN(addr);
>
> What part of vm_unmapped_area() is going to duplicate this special
> aligning logic we need on sparc?

The idea there is that you can specify the desired alignment mask and
offset using info.align_mask and info.align_offset.

Now, I just noticed that the old code actually always uses an
alignment offset of 0 instead of basing it on pgoff. I'm not sure why
that is, but it looks like this may be an issue ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
