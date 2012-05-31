Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2EaUld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:41:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2EaUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:41:31 -0400
Date: Thu, 31 May 2012 13:41:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Mackey <tdmackey@twitter.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com
Subject: Re: [PATCH v4] slab/mempolicy: always use local policy from interrupt
 context
In-Reply-To: <1338429749-5780-1-git-send-email-tdmackey@twitter.com>
Message-ID: <alpine.DEB.2.00.1205311340170.2764@chino.kir.corp.google.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org> <1338429749-5780-1-git-send-email-tdmackey@twitter.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, David Mackey wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> slab_node() could access current->mempolicy from interrupt context.
> However there's a race condition during exit where the mempolicy
> is first freed and then the pointer zeroed.
> 
> Using this from interrupts seems bogus anyways. The interrupt
> will interrupt a random process and therefore get a random
> mempolicy. Many times, this will be idle's, which noone can change.
> 
> Just disable this here and always use local for slab
> from interrupts. I also cleaned up the callers of slab_node a bit
> which always passed the same argument.
> 
> I believe the original mempolicy code did that in fact,
> so it's likely a regression.
> 
> v2: send version with correct logic
> v3: simplify. fix typo.
> Reported-by: Arun Sharma <asharma@fb.com>
> Cc: penberg@kernel.org
> Cc: cl@linux.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> [tdmackey@twitter.com: Rework patch logic and avoid dereference of current 
> task if in interrupt context.]
> Signed-off-by: David Mackey <tdmackey@twitter.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for following up on this.
