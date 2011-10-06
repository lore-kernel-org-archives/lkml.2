Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935882Ab1JFUpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 16:45:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1JFUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 16:45:48 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=msyzJTVhAHgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=Hsptb0i6piVC7Twp2wYA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Date: Thu, 06 Oct 2011 16:45:45 -0400
In-Reply-To: <20111006203358.GA5985@redhat.com>
References: <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com>
	 <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com>
	 <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com>
	 <1317925615.4729.14.camel@gandalf.stny.rr.com> <4E8DF385.3070009@zytor.com>
	 <20111006183841.GC2505@redhat.com>
	 <1317929656.4729.22.camel@gandalf.stny.rr.com>
	 <20111006203358.GA5985@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317933947.4729.25.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 16:33 -0400, Jason Baron wrote:

> > Then have the record_jumplabel.c (or whatever it's called) find all the
> > jmps at run time, and convert them into the appropriate nop.
> > 
> 
> I'd prefer to do this at build-time as hpa said. We don't want there to
> be some race b/w patching in the no-ops and taking an incorrect branch.

Yep, this record_jumplabel.c would execute at build time. Just like the
record_mcount.c does.

> 
> > Then at runtime patching, the jumplabel code could figure out what size
> > jump it needs to replace it.

The runtime patching is when we can figure out what size the compiler
used. That wont change. It should be pretty trivial to do. I can't see
any races here.

-- Steve




