Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359Ab1JFWUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:20:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965348Ab1JFWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:20:50 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=bRjG9fRkdTCjW9-B8xYA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
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
Date: Thu, 06 Oct 2011 18:20:47 -0400
In-Reply-To: <4E8E275F.6010801@goop.org>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
	    <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
	    <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org>
	    <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	    <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	    <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	   <1317925615.4729.14.camel@gandalf.stny.rr.com>
	   <4E8DF870.6010000@redhat.com>
	  <1317929321.4729.17.camel@gandalf.stny.rr.com> <4E8E20CD.5030207@goop.org>
	 <1317938775.4729.29.camel@gandalf.stny.rr.com> <4E8E275F.6010801@goop.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317939649.4729.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 15:10 -0700, Jeremy Fitzhardinge wrote:
> On 10/06/2011 03:06 PM, Steven Rostedt wrote:

> But bear in mind, I'm not using jump-label for tracing.  While its
> important for the "disabled" state to be quick, performance of the
> "enabled" state is also important.

Sorry, I'm still thinking jump-label for tracing over.

But that said, having the nop match is the best of both worlds.

I think having a update_jumplabel.c that is just like the
record_mcount.c which modifies the code right after it was compiled is
the best thing to do. That is, have the assembler determine what size
jumps to use and update them to nops right in the object file before
linking. This should be rather trivial to do.

-- Steve


