Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1I0Udg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:33:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1I0Udc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:33:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=mqGhUuvTw/2rmzbwNgzMh5/1JQoi9Cu9YtSAkOyc2X+tOyZ4eGn76pt0rmPNlxkGF
	8E6PXmdSFmfewkPc/AHog==
Date: Tue, 27 Sep 2011 13:33:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@gentwo.org>
cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: <alpine.DEB.2.00.1109271459180.13797@router.home>
Message-ID: <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Christoph Lameter wrote:

> Viewing free memory is usually necessary to check on reclaim activities
> (things otherwise operating normally). "free" memory (in the sense of the
> memory that an application can still allocate) is not really displayed by
> free. Wish we had a new free that avoids all the misinterpretations.
> 
> Meminfo is also requires by vmstat.
> 

Even with the patch, you could still get all this information by summing 
up the per-node meminfo in /sys/devices/system/node/nodeX/meminfo.  
Non-root users certainly need to be able to use things like numactl and be 
able to specify their own mempolicies for NUMA machines, so limiting basic 
memory state information isn't going to work.

I'd much rather just convert everything to use MB rather than KB so you 
can't determine things at a page level.  I think that gets us much closer 
to what the patch is intending to restrict.  But I also expect some 
breakage from things that just expect meminfo to be in KB units without 
parsing what the kernel is exporting.

> If we want to go down this route then we need some sort of diagnostic
> group that a user must be part of in order to allow viewing of basic
> memory statistics.
> 

It'll turn into another one of our infinite number of capabilities.  Does 
anything actually care about statistics at KB granularity these days?
