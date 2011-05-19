Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab1ESJFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:05:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65159 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab1ESJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:05:22 -0400
Subject: RE: [PATCH] ARM: sparsemem: allow pfn_valid to be overridden when
 using	SPARSEMEM
From: Will Deacon <will.deacon@arm.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mgorman@suse.de>
In-Reply-To: <0D753D10438DA54287A00B027084269764D2F73AC4@AUSP01VMBX24.collaborationhost.net>
References: <1305734639-6561-1-git-send-email-will.deacon@arm.com>
	 <0D753D10438DA54287A00B027084269764D2F73AC4@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 10:05:12 +0100
Message-ID: <1305795912.29560.19.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 19:53 +0100, H Hartley Sweeten wrote:
> On Wednesday, May 18, 2011 9:04 AM, Will Deacon wrote:
> >
> > In commit eb33575c ("[ARM] Double check memmap is actually valid with a
> > memmap has unexpected holes V2"), a new function, memmap_valid_within,
> > was introduced to mmzone.h so that holes in the memmap which pass
> > pfn_valid in SPARSEMEM configurations can be detected and avoided.

[...]

> I tested this on an EP93xx based system which uses ARCH_HAS_HOLES_MEMORYMODEL.
> The EP9307A has 64MB of memory that appears as two 32MB blocks at addresses
> 0xc0000000 and 0xc4000000.  Currently the EP93xx uses a Flat Memory model and
> the hole used to cause a Kernel OOPs before commit e80d6a24 ("[ARM] Skip memory
> holes in FLATMEM when reading /proc/pagetypeinfo"), which is where I think this
> all started.
> 
[...]

> I'm not sure what the output "should" be, but the patch does not seem to
> cause any issues.  So feel free to add:
> 
> Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks for that. It's good to know that this patch doesn't break
non-sparsemem platforms with whacky flatmem configurations :)

Will


