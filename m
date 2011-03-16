Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1CPVv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:51:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1CPVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:51:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TuMzDeuUIIxLHMYsDdyFkDUQXiMTVkVN/PVNiZMdJ38yAwHhCSg23VMCqEDpQXQ05n
         Pv2yGHBienURVHgTATUw==
Date: Wed, 16 Mar 2011 14:51:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: George Spelvin <linux@horizon.com>
cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
In-Reply-To: <20110316205139.2035.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.00.1103161352150.11002@chino.kir.corp.google.com>
References: <20110316205139.2035.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, George Spelvin wrote:

> > Where's your signed-off-by?
> 
> Somewhere under the pile of crap on my desk. :-)
> (More to the point, waiting for me to think it's good enough to submit
> For Real.)
> 

Patches that you would like to propose but don't think are ready for merge 
should have s/PATCH/RFC/ done on the subject line.

> > Nice cleanup.
> > 
> > "flag" should be unsigned long in all of these functions: the constants 
> > are declared with UL suffixes in slab.h.
> 
> Actually, I did that deliberately.  Because there's a problem I keep
> wondering about, which repeats many many times in the kernel:
> 

You deliberately created a helper function to take an unsigned int when 
the actuals being passed in are all unsigned long to trigger a discussion 
on why they are unsigned long?

> *Why* are they unsigned long?  That's an awkward type: 32 bits on many
> architectures, so we can't portably assign more than 32 bits, and on
> platforms where it's 64 bits, the upper 32 are just wasting space.
> (And REX prefixes on x86-64.)
> 

unsigned long uses the native word size of the architecture which can 
generate more efficient code; we typically imply that flags have a limited 
size by including leading zeros in their definition for 32-bit 
compatibility:

#define SLAB_DEBUG_FREE         0x00000100UL    /* DEBUG: Perform (expensive) checks on free */
#define SLAB_RED_ZONE           0x00000400UL    /* DEBUG: Red zone objs in a cache */
#define SLAB_POISON             0x00000800UL    /* DEBUG: Poison objects */
...
