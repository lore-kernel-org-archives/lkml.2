Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1EDTID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:08:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1EDTIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XczKobbgGT4zQl6BsqbkTlbAzy90pOYCEHUiaSWIJEBB4pPQG1ivc/azU3zOhfTqsw
         Y+IiZZ1/wdeXoOVNTWxQ==
Date: Wed, 4 May 2011 12:07:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@suse.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
In-Reply-To: <1304521355.2810.21.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105041203250.22426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg> <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com> <1304026464.2598.36.camel@mulgrave.site> <alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
 <1304521355.2810.21.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, James Bottomley wrote:

> Yes, but I also encountered it after I applied you patch, which is why I
> still pushed the Kconfig patch.  It's possible, since there were a huge
> number of patches flying around that the kernel base was contaminated,
> so I'll strip down to just linus HEAD + parisc coherence patches,
> reverting the Kconfig one and try again.
> 

Great, and if that works out successfully this time around I think we'll 
either need to fix each individual arch Kconfig that we know doesn't work 
well (at least parisc because of the scheduling issue) so that it at least 
enables CONFIG_NUMA implicitly for discontigmem unless CONFIG_BROKEN is 
set.

The ideal solution is probably to rely on CONFIG_NEED_MULTIPLE_NODES 
rather than CONFIG_NUMA, which is why it was introduced in the first place 
since it was duplicating data structures for both NUMA and discontigmem.  
That's apparently broken somewhere in the kernel that turned your SMP box 
into an UP.
