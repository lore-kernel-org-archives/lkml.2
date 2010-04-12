Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab0DLMZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:25:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55284 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0DLMZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:25:44 -0400
Date: Mon, 12 Apr 2010 13:24:33 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David VomLehn <dvomlehn@cisco.com>, to@dvomlehn-lnx2.corp.sa.net,
       "linux-arch@vger.kernel.org"@cisco.com, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Message-ID: <20100412122433.GB28208@flint.arm.linux.org.uk>
Mail-Followup-To: Heiko Carstens <heiko.carstens@de.ibm.com>,
	David VomLehn <dvomlehn@cisco.com>, to@dvomlehn-lnx2.corp.sa.net,
	"linux-arch@vger.kernel.org"@cisco.com, linux-arch@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	maint_arch@dvomlehn-lnx2.corp.sa.net
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net> <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 02:03:30PM +0200, Heiko Carstens wrote:
> Wouldn't it be much easier to implement panic with an illegal op and let
> the exception handler set up the pt regs structure instead? Just like some
> architectures do that already for warnings.
> Have a look at lib/bug.c and at various arch/<...>/include/asm/bug.h.
> BUG_FLAG_PANIC would do the trick.

You also have the problem that there are panic() statements before
exception vectors are setup.

Eg, using lmb, you might want to allocate a page for a L2 page table
so you can setup the exception vectors, but the lmb allocator has a
panic statement which will be used on failure to allocate a page.

The result is that you don't know why you didn't boot since there's no
diagnostics from the kernel.

At least with the current setup, merely (re)directing the kernel printk
output results in something you can read.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
