Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0LBVct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:32:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37105 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0LBVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:32:48 -0500
Date: Thu, 2 Dec 2010 21:32:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/02] omap: dsp: remove shm from normal memory
Message-ID: <20101202213213.GI10461@n2100.arm.linux.org.uk>
References: <1289440225-27221-1-git-send-email-omar.ramirez@ti.com> <1289440225-27221-2-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289440225-27221-2-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 07:50:24PM -0600, Omar Ramirez Luna wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
> 
> Also, don't be picky about the location, which incidentally fixes the
> build since MEMBLOCK_REAL_LIMIT is gone on 2.6.37.

That comment is wrong.  memblock_alloc() is still as picky as the
original.

phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
{
        return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
}

        /* Pump up max_addr */
        if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
                end = memblock.current_limit;

and current_limit is initialized to what was MEMBLOCK_REAL_LIMIT.  So,
memblock_alloc() will always allocate from lowmem.
