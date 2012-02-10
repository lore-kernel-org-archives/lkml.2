Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2BJNOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:14:39 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:48160 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2BJNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:14:38 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 08:14:38 EST
Subject: Re: mm/slab.c: remove effectively dead code from kmem_cache_create
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: daniel.santos@pobox.com, Daniel Santos <danielfsantos@att.net>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120209143924.886e0ff6.akpm@linux-foundation.org>
References: <4F334897.5010405@att.net>
	 <20120209143924.886e0ff6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 10 Feb 2012 15:06:41 +0200
Message-ID: <1328879201.13624.52.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 14:39 -0800, Andrew Morton wrote:
> kmem_cache_create() is called extremely rarely, so the performance
> benefit here is negligible.
> 
> We could presumably avoid two of those ifdefs by defining SLAB_RED_ZONE
> and SLAB_STORE_USER to be zero if !defined(DEBUG).  Personally I think
> that's a bit too subtle and would prefer the explicit ifdefs.
> 
> In my x86_64 allnoconfig build the patch reduces slab.o's text size
> from 12859 bytes to 12812.  I'll let Pekka decide if that's worth it ;)

The text savings are worth it but I'd really prefer to see
include/linux/slab.h patched to define debugging flags as zero for
non-CONFIG_SLAB_DEBUG and let GCC eliminate the dead code for us.

			Pekka

