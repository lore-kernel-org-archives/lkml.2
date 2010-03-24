Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab0CXTtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:49:41 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41963 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0CXTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:49:39 -0400
Date: Wed, 24 Mar 2010 14:49:33 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
In-Reply-To: <1269458528.2849.2.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1003241443520.14329@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241414270.14329@router.home> <1269458528.2849.2.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Eric Dumazet wrote:

> Are we allowed to nest in these two functions ?

This is kmem_cache_close() no danger of nesting.

> These are debugging functions, what happens if kmalloc() returns NULL ?

Then you return ENOMEM and the user gets an error. We already do that in
validate_slab_cache().

Hmmm... In this case we called from list_slab_objects() which gets called
from free_partial() (which took a spinlock!) which gets called from
kmem_cache_close().

Its just a debugging aid so no problem if it fails. GFP_ATOMIC?


