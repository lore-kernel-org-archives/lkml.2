Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1AGH3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:29:47 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1AGH3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:29:45 -0500
Message-ID: <4D26C179.7030704@kernel.dk>
Date: Fri, 07 Jan 2011 08:32:09 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
References: <20110107110513.30776114.sfr@canb.auug.org.au>
In-Reply-To: <20110107110513.30776114.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07 01:05, Stephen Rothwell wrote:
> Hi Jens,
> 
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/platforms/built-in.o: In function `.pmf_get_function':
> (.text+0x723c): undefined reference to `.kref_get'
> arch/powerpc/platforms/built-in.o: In function `.pmf_unregister_driver':
> (.text+0x72c8): undefined reference to `.kref_get'
> arch/powerpc/platforms/built-in.o: In function `.pmf_do_functions':
> (.text+0x793c): undefined reference to `.kref_get'
> arch/powerpc/platforms/built-in.o: In function `.__pmf_find_function':
> (.text+0x7c80): undefined reference to `.kref_get'
> arch/powerpc/platforms/built-in.o: In function `.pmf_register_driver':
> (.text+0x8044): undefined reference to `.kref_get'
> arch/powerpc/platforms/built-in.o:(.text+0x8310): more undefined references to `.kref_get' follow
> lib/lib.a(kref.o):(__ksymtab+0x10): undefined reference to `kref_get'
> drivers/built-in.o: In function `.get_current_tty':
> (.text+0x60970): undefined reference to `.kref_get'
> drivers/built-in.o: In function `.__proc_set_tty':
> tty_io.c:(.text+0x61624): undefined reference to `.kref_get'
> drivers/built-in.o: In function `.tty_init_dev':
> (.text+0x64d2c): undefined reference to `.kref_get'
> drivers/built-in.o: In function `.tty_open':
> tty_io.c:(.text+0x64ee4): undefined reference to `.kref_get'
> tty_io.c:(.text+0x64f20): undefined reference to `.kref_get'
> drivers/built-in.o:tty_io.c:(.text+0x64f58): more undefined references to `.kref_get' follow
> 
> Caused by commit 15454034cb3021d8bb9d21b4f35072a809197fdd ("block: add
> internal hd part table references") which removes kref_get() instead of
> kref_test_and_get()!
> 
> This really wasn't tested, right?

Irk, it was tested and booted, but apparently I merged the first bad
version of the patch.

> I have used the block tree from next-20110106 for today.

Thanks, I'll get this fixed up now.


-- 
Jens Axboe

