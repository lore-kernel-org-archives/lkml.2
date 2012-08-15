Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2HOPgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:36:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38424 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab2HOPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:36:16 -0400
Date: Wed, 15 Aug 2012 16:35:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 27/31] arm64: Loadable modules
Message-ID: <20120815153538.GA14264@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-28-git-send-email-catalin.marinas@arm.com>
 <201208151523.21447.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151523.21447.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:23:21PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +
> > +void *module_alloc(unsigned long size)
> > +{
> > +       return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
> > +                                   GFP_KERNEL, PAGE_KERNEL_EXEC, -1,
> > +                                   __builtin_return_address(0));
> > +}
> > +
> 
> What is the reason for using a separate virtual address range for the
> modules instead of falling back to the default module_alloc function
> that uses vmalloc_exec()?

Primarily branch relocation, we have a limitation to 128MB branch range.
The alternative would be to always compile the modules with a large
memory model but we may lose some performance and could make the
relocation handling even harder. What we do now is pretty much similar
to static linking but at module load time.

-- 
Catalin
