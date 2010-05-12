Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0ELVb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:31:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43142 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0ELVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:31:27 -0400
Date: Wed, 12 May 2010 22:30:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] MMC: at91_mci: modify cache flush routines
Message-ID: <20100512213059.GF22371@n2100.arm.linux.org.uk>
References: <20100511134409.GB27201@n2100.arm.linux.org.uk> <1273597793-28104-1-git-send-email-nicolas.ferre@atmel.com> <20100512141929.80c13953.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512141929.80c13953.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:19:29PM -0700, Andrew Morton wrote:
> The flush_kernel_dcache_page() documentation specifically says that
> thou shalt run flush_kernel_dcache_page() _prior_ to kunmapping the
> page.

Hmm, interesting - I can't see why that would be, but it doesn't make
any difference for ARM (and this is an ARM only driver).

> I don't know if that makes a difference in the real world, but heck why
> not:

In the interests of stopping cut'n'paste bugs into other drivers, I'd
say this is a good idea even if it makes no difference to ARM.

> However, I'm wondering why you chose flush_kernel_dcache_page() instead
> of plain old flush_dcache_page().  Is this a pagecache or possibly
> direct-io page we're dealing with here?

It's whatever the block layers hand us - which would be page cache pages,
and I'd assume also DIO pages (I'm not up on DIO stuff though.)

It's also my understanding that the preferred interface for drivers which
write to page cache pages is flush_kernel_dcache_page() rather than
flush_dcache_page().
