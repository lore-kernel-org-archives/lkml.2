Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0JOKxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:53:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0JOKxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:53:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
Date: Fri, 15 Oct 2010 12:53:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1287135981-17604-23-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151253.15653.arnd@arndb.de>
X-Provags-ID: V02:K0:V8i2By3ykfQen8dQlHYnCQBduUI2Q/fYPTQMAKtVnuY
 5jV3zu4odTdMvQsj7COOnZYDMxra9IhFiPu+i+QNDUynEQCe/N
 n0gCtmIkQ95UEkjyiD4Y5LegE10edjTxDt2QdtEqRwWsDeuRi6
 eGUQwSfvYlQxeNnGsfHPPb3F1MQR3R5cRqRWdVR+Hwmo2yjIMe
 gqs1GFcRiLRjA9sQ3bsUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010, Akinobu Mita wrote:
> minix bit operations are only used by minix filesystem and useless
> by other modules.

Right.
 
> This provides new config option CONFIG_MINIX_FS_LITTLE_ENDIAN and
> CONFIG_MINIX_FS_NATIVE_ENDIAN that each architecture selects one of which.
> Then we can remove minix bit operations from asm/bitops.h from all
> architectures by making them minix filesystem local macros.

I would say that any architecture that defines minix bitops as
little-endian is broken and we should not even need the #define.

You have defined these as "native endian":

always LE:
	alpha, blackfin, ia64, score, tile, x86

always BE:
	h8300, microblaze, s390, sparc

configurable:
	m32r, mips, sh, xtensa

The only ones among these that possibly ever cared about mounting minix
file systems on a big-endian kernel are really old sparc and mips systems,
everyone else probably never noticed their mistake.

I'd say let's define the minix bitops as always LE and be done with it.

	Arnd
