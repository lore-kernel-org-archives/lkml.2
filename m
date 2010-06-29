Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0F2PrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:47:13 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:55784 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0F2PrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:47:12 -0400
Date: Tue, 29 Jun 2010 10:47:09 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kmem_cache_destroy() badness with SLUB
In-Reply-To: <1277688701.4200.159.camel@pasglop>
Message-ID: <alpine.DEB.2.00.1006291046230.16135@router.home>
References: <1277688701.4200.159.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Benjamin Herrenschmidt wrote:

> So if the slab is created -and- destroyed at, for example, arch_initcall
> time, then we hit a WARN in the kobject code, trying to dispose of a
> non-existing kobject.

Yes dont do that.

> Now, at first sight, just adding the same test to sysfs_slab_remove()
> would do the job... but it all seems very racy to me.

Yes lets leave as is. Dont remove slabs during boot.

> Shouldn't we have a mutex around those guys ?

At boot time?

