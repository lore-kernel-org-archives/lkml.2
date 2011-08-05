Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1HEUYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:24:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1HEUYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:24:01 -0400
Message-ID: <4E3C5154.2050307@zytor.com>
Date: Fri, 05 Aug 2011 13:23:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: luto@mit.edu, x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com>
In-Reply-To: <20110805200945.GA14014@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 01:09 PM, Andi Kleen wrote:
> 
> Andy,
> 
> We found that your new vsyscall emulation in
> 
> commit 5cec93c216db77c45f7ce970d46283bcb1933884
> Author: Andy Lutomirski <luto@MIT.EDU>
> Date:   Sun Jun 5 13:50:24 2011 -0400
> 
>     x86-64: Emulate legacy vsyscalls
> 
> breaks JITs that execute x86 code and use the legacy vsyscalls.
> 
> The problem is that the JIT translates the vsyscall page into
> its code buffer and executes the "int 0xcc" there. Then 
> when the kernel gets the interrupt it doesn't see the vsyscall
> page as the source and crashes the program.
> 
> For some reason several modern executables also seem
> to still use the old vsyscall page, so this problem can be hit
> quickly.
> 
> This happened with pin (http://www.pintool.org/), however
> I expect it will affect all user space x86 JITs (valgrind, 
> dynamo, qemu-user, etc.)
> 
> What to do? Right now this broke existing setups.
> 

I have to say I believe that trying to JIT the vdso or vsyscall pages is
extremely dubious at best.  They are fundamentally different from normal
user space in that the kernel can muck with them any time, without
notifying userspace about it.  The other aspect of this is that this is
about the legacy vsyscall page, which we're trying to get rid of, partly
because of security problems.

As such, it's not entirely obvious what the right thing to do here is.
On one hand, it "break user space" but on the other hand that is
userspace doing something fundamentally broken in the first place.

	-hpa

