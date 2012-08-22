Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab2HVH4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:56:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab2HVH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:56:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Date: Wed, 22 Aug 2012 07:56:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208212014.01837.arnd@arndb.de> <20120821220145.GA27934@arm.com>
In-Reply-To: <20120821220145.GA27934@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220756.31149.arnd@arndb.de>
X-Provags-ID: V02:K0:ju/4ZPxY5uB8Kn7yV7LB2SYD0t5yVTOrOsqCCidpJg7
 PrwtMKcOf3MfRgUbrZeuoxyHfI5jch+n4Ypu3lz4ogAMNia/v1
 wyW7llHIXH8LX573+5NQXryO+lbQHkI0LUhGz2oO6RCcuXhj6j
 8NqT/1v6ipxHonmA+5c0jzILRIRJKrez4FCM0oy9JcHheqbe3I
 IwKTlSDGILpdhNz8DKJUJLEcRz1N9DOgG5fPWqrxGBRtldLada
 jI/g8rmOsv1PlpeIwCWTWuWbIeBbujIoNe3V97/pBDY1XCmw0X
 80BHUWaoU3+gYsM8CGCnLZ7MeQhboX06lJ3Yg5uuRKT678KiK+
 x+8kO0y1z/GiKpfVqgCU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Catalin Marinas wrote:
> As I understand, sys_mmap_pgoff can be used instead of sys_mmap2 on new
> 32-bit architectures. But on 64-bit architectures we don't have
> sys_mmap2, only sys_mmap with the difference that the last argument is
> the offset in bytes (and multiple of PAGE_SIZE) rather than in pages. So
> unless we change the meaning of this last argument for sys_mmap, we
> cannot just define it to sys_mmap_pgoff.
> 
> Since the other 64-bit architectures seem to have a sys_mmap wrapper
> that does this:
> 
>         sys_mmap_pgoff(..., off >> PAGE_SHIFT);
> 
> I think AArch64 should also use the same sys_mmap convention. We can
> make this wrapper generic.

But the wrapper can just as well be part of glibc, which already has
one. There is no reason for the kernel to export two generic interfaces
for mmap when one of them only works on 64 bit and the other one is
good for both 32 and 64 bit.

All the other 64 bit architectures (besides tile) were added to the
kernel before we had sys_mmap_pgoff.

	Arnd
