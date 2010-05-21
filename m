Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0EUOHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:07:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0EUOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:07:18 -0400
Date: Fri, 21 May 2010 10:07:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] mmc: add an ioctl for erasing
Message-ID: <20100521140714.GB15070@infradead.org>
References: <4BF68EFC.70101@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF68EFC.70101@nokia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 04:47:40PM +0300, Adrian Hunter wrote:
>> From f3baf566eb33a22bf12a48e4cdc7c99611bde934 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Wed, 5 May 2010 14:07:55 +0300
> Subject: [PATCH] mmc: add an ioctl for erasing
>
> As SD and MMC cards have a NAND core, they can support an erase
> operation that is typically 10x to 100x faster than writing.
>
> In addition, eMMCv4.4 also offers:
> 	o Secure Erase
> 	o Trim
> 	o Secure Trim
>
> The "secure" variants also ensure that any copies of the data
> (for example remnants of garbage collection) are also erased.
>
> "Trim" is the same as "erase" except that individual sectors
> can be erased instead of whole Erase Groups.
>
> The Erase Operation and its variants are not supported by
> default and drivers must set MMC_CAP_ERASE.  This is because
> the operation can take a long time and drivers that rely on
> polling the status may perform very badly.  Also drivers
> may need changes to support the very long erase timeouts.

Please don't add new device specific ioctls.  Just implement the
block layer discard operation to make the discard ioctl work on MMC
device.  We can talk about adding a secure erase variant of it then.

