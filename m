Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1JGTdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:33:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1JGTdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:33:10 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=gxfjmhR6zbwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=tBYeR_1S0UNBOaloq88A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH][RFC] jump_labels/x86: Use either 5 byte or 2 byte jumps
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Richard Henderson <rth@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org
Date: Fri, 07 Oct 2011 15:33:08 -0400
References: <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org>
	 <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com>
	 <4E8DF870.6010000@redhat.com>
	 <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	 <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
	 <1318007374.4729.58.camel@gandalf.stny.rr.com>
	 <20111007185214.GD2978@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318015989.4729.72.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 15:21 -0400, Steven Rostedt wrote:

> > > +	/*
> > > +	 * This is specific to x86. The jump_table is stored in three
> > > +	 * long words. The first is the location of the jmp target we
> > > +	 * must update.
> > > +	 */
> > > +	cnt = size / sizeof(uint_t);
> > > +
> > > +	for (i = 0; i < cnt; i += 3)
> > > +		if (0)make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));

I just compiled and booted the 

-		if (0)make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));
+		make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));

version, and it still works.

Phew!

-- Steve


