Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935882Ab1JFWGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:06:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab1JFWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:06:16 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=IBu5faARPO_BLb2dZK8A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Richard Henderson <rth@redhat.com>, Jason Baron <jbaron@redhat.com>,
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
Date: Thu, 06 Oct 2011 18:06:13 -0400
In-Reply-To: <4E8E20CD.5030207@goop.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	   <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	   <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	   <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	   <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	   <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	  <1317925615.4729.14.camel@gandalf.stny.rr.com>
	  <4E8DF870.6010000@redhat.com>
	 <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317938775.4729.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 14:42 -0700, Jeremy Fitzhardinge wrote:
> On 10/06/2011 12:28 PM, Steven Rostedt wrote:
> >> (2) Always reserve 5 bytes of space, but if the distance is small enough
> >> patch in a 2-byte jump.  That doesn't help with the icache footprint.
> > I don't think this one is worth it.
> 
> I disagree.  This is what I benchmarked as having a 5% improvement.  If
> squashing out the padding helps, then that's a separate optimisation.

But it only speeds up the tracing case. The non-tracing case is a nop
and 5bytes is 5bytes regardless.

Did you see a 5% speed up while tracing was happening? How did you do
your test. I find a 5 byte compared to a 2 byte jump being negligible
with the rest of the overhead of tracing, but I could be wrong.

-- Steve
 

