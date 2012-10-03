Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2JCSVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:21:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33267 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab2JCSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:21:22 -0400
Date: Wed, 3 Oct 2012 11:21:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: init_kmem_cache_cpus() and put_cpu_partial() can
 be static
In-Reply-To: <0000013a26fc13cf-2a85d946-fe2b-4180-a5a0-fbe6781a2934-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1210031119290.2412@chino.kir.corp.google.com>
References: <20120928083405.GA23740@localhost> <alpine.DEB.2.00.1210022154520.8723@chino.kir.corp.google.com> <0000013a26fc13cf-2a85d946-fe2b-4180-a5a0-fbe6781a2934-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Christoph Lameter wrote:

> > > Acked-by: Glauber Costa <glommer@parallels.com>
> > > Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> >
> > Acked-by: David Rientjes <rientjes@google.com>
> >
> > I think init_kmem_cache_cpus() would also benefit from just being inlined
> > into alloc_kmem_cache_cpus().
> 
> The compiler will do that if it is advantageous.
> 

Which it obviously does with -O2, but I think it would be advantageous to 
do this at the source code level as well since we have a function with a 
single caller, which happens to be marked inline itself, but we're not 
inline.  It seems cleaner to me, but it's only a suggestion.  Thanks.
