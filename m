Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1GaSuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:50:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1GaSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:50:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=v3GdTQOWK/s7157vDkzK7m6EiVlnQwEK3xFcm9PeXodikzKL+iwMjBGNfEWUEyBcd
	NEn/mV9+1krUuzQcRPiPQ==
Date: Sun, 31 Jul 2011 11:50:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1107291002570.16178@router.home>
Message-ID: <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Christoph Lameter wrote:

> > We haven't come up with a solution to keep struct page size the same but I
> > think it's a reasonable trade-off.
> 

We won't be coming up with a solution to that since the alignment is a 
requirement for cmpxchg16b, unfortunately.

> The change requires the page struct to be aligned to a double word
> boundary. There is actually no variable added to the page struct. Its just
> the alignment requirement that causes padding to be added after each page
> struct.
> 

Well, the counters variable is added although it doesn't increase the size 
of the unaligned struct page because of how it is restructured.  The end 
result of the alignment for CONFIG_CMPXCHG_LOCAL is that struct page will 
increase from 56 bytes to 64 bytes on my config.  That's a cost of 128MB 
on each of my client and server 64GB machines for the netperf benchmark 
for the ~2.3% speedup.
