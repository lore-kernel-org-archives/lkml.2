Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1HBUCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:02:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab1HBUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:02:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=n2nMM0ClH4qQrEEHWkK3jlMp1lOtyXOHIN2ILQ5cob+gC0ZZQp7u5kbHkd07qYVxD
	a2aHqJpB/5SwGZgku945g==
Date: Tue, 2 Aug 2011 13:02:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1108021131250.21126@router.home>
Message-ID: <alpine.DEB.2.00.1108020938200.1114@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com> <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com> <alpine.DEB.2.00.1108020913180.18965@router.home>
 <alpine.DEB.2.00.1108020915370.1114@chino.kir.corp.google.com> <alpine.DEB.2.00.1108021131250.21126@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, Christoph Lameter wrote:

> The per cpu partial lists only add the need for more memory if other
> processors have to allocate new pages because they do not have enough
> partial slab pages to satisfy their needs. That can be tuned by a cap on
> objects.
> 

The netperf benchmark isn't representative of a heavy slab consuming 
workload, I routinely run jobs on these machines that use 20 times the 
amount of slab.  From what I saw in the earlier posting of the per-cpu 
partial list patch, the min_partial value is set to half of what it was 
previously as a per-node partial list.  Since these are 16-core, 4 node 
systems, that would mean that after a kmem_cache_shrink() on a cache that 
leaves empty slab on the partial lists that we've doubled the memory for 
slub's partial lists systemwide.
