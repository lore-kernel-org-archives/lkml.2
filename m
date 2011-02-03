Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab1BCFF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 00:05:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab1BCFF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 00:05:26 -0500
Message-ID: <4D4A3782.3050702@zytor.com>
Date: Wed, 02 Feb 2011 21:05:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:18 AM, Stefano Stabellini wrote:
> x86/mm/init: respect memblock reserved regions when destroying mappings
> 
> In init_memory_mapping we are destroying all the mappings between
> _brk_end and _end, no matter if some memory areas in that range have
> been reserved using memblock_x86_reserve_range.
> Besides if _end is not pmd aligned we might destroy the
> mappings for valid memory between _end and the following pmd.
> 
> In order to avoid this problem, before clearing any pmds we check if the
> corresponding memory area has been reserved and we only destroy the
> mapping if it hasn't.
> 
> We found this problem because under Xen we have a valid mapping at _end,
> and if _end is not pmd aligned the current code destroys the initial
> part of it.
> 
> In practice this fix does not have any impact on native.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

How on Earth would you end up with a reserved region *inside the BRK*?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

