Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1J2Mx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 08:53:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57138 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab1J2Mx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 08:53:58 -0400
Date: Sat, 29 Oct 2011 13:53:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, msb@chromium.org,
        linux-kernel@vger.kernel.org, sergiu@chromium.org,
        Bryan Freed <bfreed@chromium.org>, akpm@linux-foundation.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
Message-ID: <20111029125342.GB19187@n2100.arm.linux.org.uk>
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org> <4EABBBD3.5030700@gmail.com> <20111029093458.GX19187@n2100.arm.linux.org.uk> <4EABDDBE.5080407@gmail.com> <20111029115507.GA19187@n2100.arm.linux.org.uk> <4EABF4C2.7000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EABF4C2.7000104@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 02:42:42PM +0200, Marco Stornelli wrote:
> Ok, I understand, but other question: isn't there any way to reserve  
> normal memory? Or at least, hasn't the mem kernel option any effect from  
> that point of view?

mem= can be used to redefine the available memory to the kernel, but
then you have to have some way to define a region of the memory you've
excluded to the kernel to use for ramoops.

A platform can also use the memblock stuff to extract some memory
dynamically from the information passed from the firmware - by using
memblock_alloc + memblock_remove + memblock_free.  The memblock_remove
call will take the memory out of the available memory to the kernel,
and thus will prevent it being mapped.

This must be done via the ->reserve callback in the ARM board/SoC
record (it can't be done later because the memory will have already
been mapped.)
