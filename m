Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0K2J7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:59:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37284 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab0K2J7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:59:44 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
Date: Mon, 29 Nov 2010 10:59:40 +0100
In-Reply-To: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
	(Hui Zhu's message of "Mon, 29 Nov 2010 11:56:15 +0800")
Message-ID: <87r5e4lab7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu <teawater@gmail.com> writes:

> Now, there are a lot of ways to debug the Linux kernel with GDB, like
> qemu, kgtp or kgdb and so on.
> But the developer more like add a printk. It have a lot of reason, a big one is:
> (gdb) p ret
> $3 = <value optimized out>
> And the code execution order is not right.

Really the right place to fix a lot of this would be gcc (and perhaps
gdb). I suspect with some careful work the debugging experience
for -O2 could be improved a lot.
I also believe the latest gccs already have improvements in this area.

>
> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
> generate enough debug message with file with -O2.
> So GDB cannot work very well with Linux kernel.
>
> So I make a patch that add a option in "Kernel hacking" called "Close
> GCC optimization".  It will make kernel be built without -O2.


You need to at least keep aggressive inlining for header files,
otherwise there will be too much code bloat and bad code.

Like -O1 -finline-functions ? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
