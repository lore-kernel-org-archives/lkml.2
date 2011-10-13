Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1JMWDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:03:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab1JMWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:03:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=T5fkrVxLHyaR9XNJu8KKtCVETiiZoGbA+IygGlqEWNhPzN9JJ6hX+AIqyhKBezBpI
	dtHFnHBEhxkH/mBjJ0I1g==
Date: Thu, 13 Oct 2011 15:02:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Satoru Moriya <satoru.moriya@hds.com>, Con Kolivas <kernel@kolivas.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <4E97541F.9050805@redhat.com>
Message-ID: <alpine.DEB.2.00.1110131501490.24853@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516D459@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110131337580.24853@chino.kir.corp.google.com>
 <4E97541F.9050805@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Rik van Riel wrote:

> Userspace cannot be responsible, for the simple reason that
> the allocations might be done in the kernel.
> 
> Think about an mlocked realtime program handling network
> packets. Memory is allocated when packets come in, and when
> the program calls sys_send(), which causes packets to get
> sent.
> 
> I don't see how we can make userspace responsible for
> kernel-side allocations.
> 

All of this is what Minchan was proposing by allowing a mempool of kernel 
memory to be preallocated and managed by the memory controller.
