Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2F0OWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:22:42 -0400
Received: from linux-sh.org ([111.68.239.195]:52847 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab2F0OWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:22:40 -0400
Date: Wed, 27 Jun 2012 23:22:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] asm-generic: fix compile breakage "'TAINT_WARN'
 undeclared"
Message-ID: <20120627142233.GK24033@linux-sh.org>
References: <Pine.LNX.4.64.1206271507200.24173@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206271507200.24173@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 03:52:27PM +0200, Guennadi Liakhovetski wrote:
> TAINT_WARN is defined in kernel.h and used in asm-generic/bug.h. Not 
> including kernel.h there breaks build on sh:
> 
> In file included from linux/include/linux/thread_info.h:54,
>                  from linux/include/linux/preempt.h:9,
>                  from linux/include/linux/spinlock.h:50,
>                  from linux/include/linux/mmzone.h:7,
>                  from linux/include/linux/gfp.h:4,
>                  from linux/include/linux/mm.h:8,
>                  from linux/arch/sh/kernel/asm-offsets.c:13:
> linux/arch/sh/include/asm/thread_info.h: In function 'set_restore_sigmask':
> linux/arch/sh/include/asm/thread_info.h:172: error: 'TAINT_WARN' undeclared (first use in this function)
> linux/arch/sh/include/asm/thread_info.h:172: error: (Each undeclared identifier is reported only once
> linux/arch/sh/include/asm/thread_info.h:172: error: for each function it appears in.)
> 
> Also, since nothing in bug.h is usable from assembly, it is safe to extend 
> the "#ifndef __ASSEMBLY__" block over all WARN() macros.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Already fixed in mainline.
