Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2CTLnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:43:15 -0400
Received: from mx0.aculab.com ([213.249.233.131]:44646 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752939Ab2CTLnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:43:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] net: bpf_jit: Simplify code by always using offset8 or offset32.
Date: Tue, 20 Mar 2012 11:41:46 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6EB0@saturn3.aculab.com>
In-Reply-To: <cfb04c3fe59e421093f035c035c88b51.squirrel@webmail.greenhost.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net: bpf_jit: Simplify code by always using offset8 or offset32.
Thread-Index: Ac0GjVo68y9K5pYeRP+gyPzvqjPOhgAACYUQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Indan Zupancic" <indan@nul.nu>, "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Will Drewry" <wad@chromium.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kernel-hardening@lists.openwall.com>, <netdev@vger.kernel.org>,
        <x86@kernel.org>, <arnd@arndb.de>, <davem@davemloft.net>,
        <hpa@zytor.com>, <mingo@redhat.com>, <oleg@redhat.com>,
        <peterz@infradead.org>, <rdunlap@xenotime.net>,
        <mcgrathr@chromium.org>, <tglx@linutronix.de>, <luto@mit.edu>,
        <eparis@redhat.com>, <serge.hallyn@canonical.com>, <djm@mindrot.org>,
        <scarybeasts@gmail.com>, <pmoore@redhat.com>,
        <akpm@linux-foundation.org>, <corbet@lwn.net>, <markus@chromium.org>,
        <coreyb@linux.vnet.ibm.com>, <keescook@chromium.org>
X-OriginalArrivalTime: 20 Mar 2012 11:42:03.0635 (UTC) FILETIME=[78425C30:01CD068E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Tue, March 20, 2012 13:59, Eric Dumazet wrote:
> > On Tue, 2012-03-20 at 13:24 +1100, Indan Zupancic wrote:
> >
> >> If it does then perhaps the fast path should be made faster by
inlining
> >> the code instead of calling a function which may not be cached.
> >>
> >
> > inlining 400 times a sequence of code is waste of icache you
probably
> > missed this.
> 
> Well, according to you most filters were small, inling 26 bytes a few
> times should be faster than calling an external function. Not 
> all calls need to be inlined either.

I wouldn't bet on it.
If the number of arguments is small enough to fit in the registers,
the called function doesn't to save any registers, and the call
doesn't mean the calling code runs out of registers,
the actual cost of the call will be minimal.

OTOH the benefit of only having to fetch the code once,
and the higher likelyhood that it will be in the i-cache
from some other use, will make the version with the calls
faster.

You need to do real benchmarks on a real system running
a real workload to find out which is better.
Oh and beware that changes in which code shares cache
lines can have a measuarable effect (typified by unrelated
changes affecting measured performance).

	David


