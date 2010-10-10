Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0JJPH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:07:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56751 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0JJPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sXsr3gUxTPRmjHBZ+5SOKLSKv3fdMz7fwfGbi4HAH07k4iw8sqbS3vO9nEMUN92PDM
         O9AvtcyVK8qWiQjb+w9NySY54QMD69Ra3H3xoMAFaavKV6AQKOKOcnUYyrRUGeJYVegx
         zlMJFzHVIgZfbW/HjoKhQBEj4MIDY6QNFI/PQ=
MIME-Version: 1.0
In-Reply-To: <20101008102433.GA24208@infradead.org>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
	<20101008102433.GA24208@infradead.org>
Date: Mon, 11 Oct 2010 00:07:26 +0900
Message-ID: <AANLkTikjb8aTBoXm3+9ULQDB9OvdxwHcQ=BSS4aBJm9i@mail.gmail.com>
Subject: Re: [PATCH 1/5] bitops: add generic implementation of ext2 atomic
 bitops by test_and_{set,clear}_bit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/8 Christoph Hellwig <hch@infradead.org>:
> On Fri, Oct 08, 2010 at 07:03:09PM +0900, Akinobu Mita wrote:
>> This introduces asm-generic header file for generic implementation of
>> ext2 atomic bit operations by test_and_set_bit() and test_and_clear_bit().
>>
>> alpha, arm, cris, frv, ia64, m68k, mn10300, parisc, powerpc, s390,
>> sparc64, x86, xtensa can use this header file in its asm/bitops.h.
>
> Care to rename the functions to le_* instead of ext2_* while you're at
> it and documenting their semantics?

OK, as several people requested in another threads, I'll introduce
little endian bit operations for all architectures and rename ext2
bitops to le bitops.

BTW, I have a question about ext2 atomic bit operations.

Some architectures use spinlock to implement it
(asm-generic/bitops/ext2-atomic.h). Most other architectures use
test_and_set_bit() and test_and_clear_bit() as this patch shows.

Why are there two implementations? test_and_{set,clear}_bit() are more
costly operations than spinlock for some architectures?
