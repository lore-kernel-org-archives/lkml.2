Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1I1Pen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:34:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1I1Pem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:34:42 -0400
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 28 Sep 2011 17:33:58 +0200
In-Reply-To: <4E833D6D.1030407@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	  <1316816432-9237-5-git-send-email-glommer@parallels.com>
	  <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>
	  <1317206124.20318.6.camel@twins> <20110928144218.6a4882e5@de.ibm.com>
	 <1317214418.24040.13.camel@twins> <4E833D6D.1030407@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317224038.24040.52.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 12:29 -0300, Glauber Costa wrote:
> On 09/28/2011 09:53 AM, Peter Zijlstra wrote:
> > On Wed, 2011-09-28 at 14:42 +0200, Martin Schwidefsky wrote:
> >
> >>> That is, am I missing some added value of all this cputime*() foo?
> >>
> >> C can do the math as long as the encoding of the cputime is simple enough.
> >> Can we demand that a cputime value needs to be an integral type ?
> >
> > I'd like to think we can ;-)
> >
> >> What I did when I wrote all that stuff is to define cputime_t as a struct
> >> that contains a single u64. That way I found all the places in the kernel
> >> that used a cputime and could convert the code accordingly.
> >
> > Indeed, that makes it a non-simple type and breaks all the C arith bits.
> >
> >> My fear is that if the cputime_xxx operations are removed, code will
> >> sneak in again that just uses an unsigned long instead of a cputime_t.
> >> That would break any arch that requires something bigger than a u32 for
> >> its cputime.
> >
> > Which is only a problem for 32bit archs, of which s390 is the only one
> > that matters, right? Hurm,. could we do something with sparse? Lots of
> > people run sparse.
> >
> Well, I think x86-32 is unlikely to ever really go away.

Sadly I'd agree with you, but that's not really the point, the only 32
bit arch that has !32 bit cputime_t is s390.

But yeah, death to ia32 (and everything else 32bit fwiw)!
