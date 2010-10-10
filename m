Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0JJQht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:37:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0JJQhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:37:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/5] bitops: add generic implementation of ext2 atomic bitops by test_and_{set,clear}_bit
Date: Sun, 10 Oct 2010 18:36:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com> <20101008102433.GA24208@infradead.org> <AANLkTikjb8aTBoXm3+9ULQDB9OvdxwHcQ=BSS4aBJm9i@mail.gmail.com>
In-Reply-To: <AANLkTikjb8aTBoXm3+9ULQDB9OvdxwHcQ=BSS4aBJm9i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010101836.52406.arnd@arndb.de>
X-Provags-ID: V02:K0:rFR9uGS2glNqXZq2eeUidoHp0kcqSK4En8GadVTtSQt
 46R1uNSZ9f4GkcgAqqu1dP0DTBnMIJSz+zU7m9PlmiB1RQS3w+
 I50jMm+N58TWrhlKO5kOKludU7SxV+WNO2lfClsi0gdMfblsGy
 /gY+//xLEx3ci0DbEzY7Qj928XTsn6p5S744nOod14LumFBCIW
 Z3Kn764FyOiceiJGwCrxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 October 2010 17:07:26 Akinobu Mita wrote:
> Some architectures use spinlock to implement it
> (asm-generic/bitops/ext2-atomic.h). Most other architectures use
> test_and_set_bit() and test_and_clear_bit() as this patch shows.
> 
> Why are there two implementations? test_and_{set,clear}_bit() are more
> costly operations than spinlock for some architectures?

I would guess that is only true on architectures that implement all atomics
using a hashed spinlock like cris, sparc32 or parisc. This way the user
can decide which spinlock to use rather than have the arch code calculate
a hash on the pointer.

This is an ext2 specific micro-optimization that I don't think makes
sense in the generic le bitops code.

	Arnd
