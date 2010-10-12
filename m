Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab0JLDjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:39:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36598 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0JLDji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jus3/16O2IR0wWSxeGwQeYisoQVcEMceeLsUROQ1dYonjgkS0ddKd4GfXxGoKR5+l5
         ZuXvnkw8NGPGL1k83ljMfo6v9Udp/rwxPlY2STkBPEOL8dFos8vQ/kSw0P8amZ+u49bF
         9WC/bGWqJMImlqGDqzLAAU73ezLn+ramku8L0=
MIME-Version: 1.0
In-Reply-To: <201010101836.52406.arnd@arndb.de>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
	<20101008102433.GA24208@infradead.org>
	<AANLkTikjb8aTBoXm3+9ULQDB9OvdxwHcQ=BSS4aBJm9i@mail.gmail.com>
	<201010101836.52406.arnd@arndb.de>
Date: Tue, 12 Oct 2010 12:39:37 +0900
Message-ID: <AANLkTik95xrOw0Y_=63EiJ-EGh95XZGeqMy_-HXorqCS@mail.gmail.com>
Subject: Re: [PATCH 1/5] bitops: add generic implementation of ext2 atomic
 bitops by test_and_{set,clear}_bit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/11 Arnd Bergmann <arnd@arndb.de>:
> On Sunday 10 October 2010 17:07:26 Akinobu Mita wrote:
>> Some architectures use spinlock to implement it
>> (asm-generic/bitops/ext2-atomic.h). Most other architectures use
>> test_and_set_bit() and test_and_clear_bit() as this patch shows.
>>
>> Why are there two implementations? test_and_{set,clear}_bit() are more
>> costly operations than spinlock for some architectures?
>
> I would guess that is only true on architectures that implement all atomics
> using a hashed spinlock like cris, sparc32 or parisc. This way the user
> can decide which spinlock to use rather than have the arch code calculate
> a hash on the pointer.

Thanks. It looks quite right.

> This is an ext2 specific micro-optimization that I don't think makes
> sense in the generic le bitops code.

OK, I'll only rename ext2 non-atomic bitops to le bitops and
keep ext2 atomic bitops for now.
