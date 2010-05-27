Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab0E0TDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:03:43 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:52158 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab0E0TDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:03:41 -0400
Date: Thu, 27 May 2010 21:04:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [BUG] slub crashes on dma allocations
Message-ID: <20100527190440.GA2205@osiris.boeblingen.de.ibm.com>
References: <20100526153757.GB2232@osiris.boeblingen.de.ibm.com>
 <alpine.DEB.2.00.1005270916220.5762@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005270916220.5762@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:17:17AM -0500, Christoph Lameter wrote:
> 
> So S390 has NUMA and the minalign is allowing very small slabs of 8/16/32 bytes?

No NUMA, but minalign is 8.

> Try this patch
> 
> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: SLUB: Allow full duplication of kmalloc array for 390
> 
> Seems that S390 is running out of kmalloc caches.
> 
> Increase the number of kmalloc caches to a safe size.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Yes, that fixes the bug. Thanks!
