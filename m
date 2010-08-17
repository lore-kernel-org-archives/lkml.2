Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab0HQPZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:25:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab0HQPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:25:49 -0400
Date: Tue, 17 Aug 2010 16:25:27 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: ralf@linux-mips.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make do_execve() take a const filename pointer
Message-ID: <20100817152526.GC6681@flint.arm.linux.org.uk>
Mail-Followup-To: David Howells <dhowells@redhat.com>, ralf@linux-mips.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100817140737.29854.22899.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817140737.29854.22899.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 03:07:37PM +0100, David Howells wrote:
> Make do_execve() take a const filename pointer so that kernel_execve() compiles
> correctly on ARM:
> 
> arch/arm/kernel/sys_arm.c:88: warning: passing argument 1 of 'do_execve' discards qualifiers from pointer target type
> 
> This also requires the argv and envp arguments to be consted twice, once for
> the pointer array and once for the strings the array points to.  This is
> because do_execve() passes a pointer to the filename (now const) to
> copy_strings_kernel().  A simpler alternative would be to cast the filename
> pointer in do_execve() when it's passed to copy_strings_kernel().
> 
> do_execve() may not change any of the strings it is passed as part of the argv
> or envp lists as they are some of them in .rodata, so marking these strings as
> const should be fine.
> 
> Further kernel_execve() and sys_execve() need to be changed to match.
> 
> This has been test built on x86_64, frv, arm and mips.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Ralf Baechle <ralf@linux-mips.org>

David,

Thanks for sorting this.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
