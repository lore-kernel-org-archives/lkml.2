Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2ADKiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:38:23 -0500
Received: from mx0.aculab.com ([213.249.233.131]:54074 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754199Ab2ADKiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 05:38:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: fix and improve cmpxchg_double{,_local}()
Date: Wed, 4 Jan 2012 10:36:34 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF2A@saturn3.aculab.com>
In-Reply-To: <1325611899.2320.111.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: fix and improve cmpxchg_double{,_local}()
Thread-Index: AczKPVjVJHj6i0WvTXyr23gPUyG/IgAjw/fQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>, "Jan Beulich" <JBeulich@suse.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, "Christoph Lameter" <cl@linux.com>,
        <linux-kernel@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>,
        <hpa@zytor.com>
X-OriginalArrivalTime: 04 Jan 2012 10:36:34.0497 (UTC) FILETIME=[BAEA7B10:01CCCACC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> BTW atomic64_set() asm() contraints are wrong :
> 
> static inline void atomic64_set(atomic64_t *v, long long i)
> {
>         unsigned high = (unsigned)(i >> 32);
>         unsigned low = (unsigned)i;
>         asm volatile(ATOMIC64_ALTERNATIVE(set)
>                      : "+b" (low), "+c" (high)
>                      : "S" (v)
>                      : "eax", "edx", "memory"
>                      );
> }
> 
> 
> ebx/ecx registers are not modified by cmpxchg8b (or the 
> atomic64_set_386 emulation). Only eax/edx can be modified.

Isn't it also possible to constrain the "memory"
constraint to only apply to '*v' not all of memory?
I can't remember the syntax off hand though...

	David


