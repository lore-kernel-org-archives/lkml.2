Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0KANiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:38:24 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:40998 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235Ab0KANiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:38:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF9bzkxGGOIS/2dsb2JhbAChVnK7cYVFBI9d
Date: Mon, 1 Nov 2010 09:38:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
	vzalloc rather than vmalloc and memset
Message-ID: <20101101133819.GA28138@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net> <20101031183913.GA26160@Krystal> <20101031174635.88f441fe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101031174635.88f441fe.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:36:13 up 207 days, 23:26,  3 users,  load average: 0.07, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 31 Oct 2010 14:39:14 -0400 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Jesper Juhl (jj@chaosbits.net) wrote:
> > > On Sat, 30 Oct 2010, Mathieu Desnoyers wrote:
> > > 
> > > > * Jesper Juhl (jj@chaosbits.net) wrote:
[...]
> > Which looks to me like a misunderstanding of the C99 standard. What you
> > do is:
> > 
> > static struct page **relay_alloc_page_array(unsigned int n_pages)
> > {
> > 	const size_t pa_size = n_pages * sizeof(struct page *);
> > 	...
> > }
> > 
> > So the compiler has no choice but to emit code that will fill in the
> > value of pa_size at runtime, because it depends on "n_pages", a
> > parameter received by the function. So pa_size is everything but
> > constant.
> > 
> > The C99 standard, section 6.7.3 (Type qualifiers) states:
> > 
> > "The implementation may place a const object that is not volatile in a
> > read-only region of storage. Moreover, the implementation need not
> > allocate storage for such an object if its address is never used."
> > 
> > So maybe gcc is kind here and it just removes this const specifier
> > without complaining, but a different compiler might be more strict and
> > fail to compile because you would be dynamically assigning a value to a
> > variable placed in read-only storage.

Actually, "object" in the C99 standard refers to global variables, not
local variables. The misunderstanding was on my part.

Sorry about that,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
