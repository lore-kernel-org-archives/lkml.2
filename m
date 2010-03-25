Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab0CYF2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:28:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab0CYF2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:28:21 -0400
Date: Thu, 25 Mar 2010 16:28:14 +1100
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nathan Fontenot <nfont@austin.ibm.com>
Subject: Re: [PATCH 1/2] mm/vmalloc: Export purge_vmap_area_lazy()
Message-ID: <20100325052814.GA7493@laptop.nomadix.com>
References: <1269417391.8599.188.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269417391.8599.188.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 06:56:31PM +1100, Benjamin Herrenschmidt wrote:
> Some powerpc code needs to ensure that all previous iounmap/vunmap has
> really been flushed out of the MMU hash table. Without that, various
> hotplug operations may fail when trying to return those pieces to
> the hypervisor due to existing active mappings.
> 
> This exports purge_vmap_area_lazy() to allow the powerpc code to perform
> that purge when unplugging devices.

You want vm_unmap_aliases(), which also flushes entries in the
per-cpu vmap allocator (and is already exported for other code
that has similar problems).

Thanks,
Nick

