Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab1KKKzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:55:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55075 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab1KKKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:55:08 -0500
Date: Fri, 11 Nov 2011 10:54:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 08/16] ARM: LPAE: Page table maintenance for the
 3-level format
Message-ID: <20111111105450.GB23243@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-9-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1111101654400.3307@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111101654400.3307@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 09:59:33PM +0000, Nicolas Pitre wrote:
> On Mon, 7 Nov 2011, Catalin Marinas wrote:
> 
> > This patch modifies the pgd/pmd/pte manipulation functions to support
> > the 3-level page table format. Since there is no need for an 'ext'
> > argument to cpu_set_pte_ext(), this patch conditionally defines a
> > different prototype for this function when CONFIG_ARM_LPAE.
> 
> Maybe it doesn't make sense to still call it cpu_set_pte_ext then?

We could do this but it adds several #ifdef's, especially if we also
change macro names like set_pte_ext(). Otherwise we could leave the
latter macro unchanged and only change the name in the processor
structure. But I think it just adds more clutter.

-- 
Catalin
