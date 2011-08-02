Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750811Ab1HBEFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:05:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab1HBEFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:05:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ri+rgUZKkkXfmccHR0Tjpz5QK7AwxxpEmzfYj0liR/2OmS/nQ7paby1vJrwM4Uk8m
	zACSEyy5Hg59Zb+SUst8Q==
Date: Mon, 1 Aug 2011 21:05:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Pekka Enberg wrote:

> Btw, I haven't measured this recently but in my testing, SLAB has
> pretty much always used more memory than SLUB. So 'throwing more
> memory at the problem' is definitely a reasonable approach for SLUB.
> 

Yes, slub _did_ use more memory than slab until the alignment of 
struct page.  That cost an additional 128MB on each of these 64GB 
machines, while the total slab usage on the client machine systemwide is 
~75MB while running netperf TCP_RR with 160 threads.
