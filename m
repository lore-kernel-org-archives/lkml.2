Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0HWTEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:04:12 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:15995 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab0HWTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:04:09 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	 <19570.38608.79434.179797@chiark.greenend.org.uk>
	 <1282580751.2605.1997.camel@laptop>
	 <19570.44367.719276.128881@chiark.greenend.org.uk>
	 <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 23 Aug 2010 20:03:57 +0100
Message-ID: <1282590237.5417.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] mlock/stack guard interaction fixup
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=zI1UDiXOKOEA:10 a=8nJEP1OIZ-IA:10 a=61Tg0FzcAAAA:8 a=YykBkRcsrZ_XObWSYhkA:9 a=sAtA7dK8N7wqwXN89RIA:7 a=jNEo3ZIbiS69w5fxBWBc_1lMoawA:4 a=wPNLvfGTeEIA:10 a=i9sELj5dCcQeSSF2:21 a=_QoHdbM2N84jIsNM:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 10:34 -0700, Linus Torvalds wrote:
> On Mon, Aug 23, 2010 at 10:18 AM, Ian Jackson
> <ijackson@chiark.greenend.org.uk> wrote:
> >
> > But you seem, like me, to be disagreeing with Linus's assertion that
> > calling mlock() on the stack is something no sane programs does ?
> 
> Note: I don't think it's generally sane to mlock() a _part_ of the stack.

Neither do I. The Xen toolstack even has a mechanism for bouncing data
to a special area for use as hypercall arguments. I expected it was just
a few corner cases which didn't use it but when I started looking into
it due to this conversation I discovered it's not as widely used as it
should be, I'm working to fix that on the Xen end.

> [...] It's also
> dubious as a way to pin particular pages in the page tables, because
> it's not necessarily something that the semantics guarantee
> (historically mlock just guarantees that they won't be swapped out,
> not that they will necessarily maintain some particular mapping).

Xen's usage doesn't require that the physical page backing an mlocked
virtual address never changes, just that it doesn't change without
obeying the regular TLB flush semantics.

Ian.
-- 
Ian Campbell

Familiarity breeds attempt.

