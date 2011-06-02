Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1FBRQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:16:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23578 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1FBRQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=YiRBhpCa+CgVMgTQiQhtFl3WNUXcmv2Zf7CRaEMmp58dJkmi3KfuA5rY1cZuf8NLjl
         eh+VP0SKGTOlOPsHJ8Kg==
Date: Thu, 2 Jun 2011 10:16:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double
 requirement
In-Reply-To: <201106021424.p52EO91O006974@lab-17.internal.tilera.com>
Message-ID: <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com>
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011, Chris Metcalf wrote:

> On an architecture without CMPXCHG_LOCAL but with DEBUG_VM enabled,
> the VM_BUG_ON() in __pcpu_double_call_return_bool() will cause an early
> panic during boot unless we always align cpu_slab properly.
> 
> In principle we could remove the alignment-testing VM_BUG_ON() for
> architectures that don't have CMPXCHG_LOCAL, but leaving it in means
> that new code will tend not to break x86 even if it is introduced
> on another platform, and it's low cost to require alignment.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: David Rientjes <rientjes@google.com>

> ---
> This needs to be pushed for 3.0 to allow arch/tile to boot.
> I'm happy to push it but I assume it would be better coming
> from an mm or percpu tree.  Thanks!
> 

Should also be marked for stable for 2.6.39.x, right?
