Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab2KESEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:04:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2KESEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:04:30 -0500
Date: Mon, 5 Nov 2012 13:03:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Subject: Re: Kdump with signed images
Message-ID: <20121105180353.GC28720@redhat.com>
References: <20121026023916.GA16762@srcf.ucam.org>
 <20121026170609.GB24687@redhat.com>
 <1351276649.18115.217.camel@falcor>
 <20121101131003.GA14573@redhat.com>
 <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
 <20121101144304.GA15821@redhat.com>
 <20121101145225.GB10269@srcf.ucam.org>
 <20121102132318.GA3300@redhat.com>
 <87boffd727.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87boffd727.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 02:32:48PM -0700, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Nov 01, 2012 at 02:52:25PM +0000, Matthew Garrett wrote:
> >> On Thu, Nov 01, 2012 at 10:43:04AM -0400, Vivek Goyal wrote:
> >> 
> >> > So I think this does satisfy the requirement matthew specified. Isn't it?
> >> > Matthew, what do you think?
> >> 
> >> Sure, if you can ensure that. You'll need to figure out how to get the 
> >> build system to sign the userspace binaries and you'll need to ensure 
> >> that they're statically linked and don't dlopen anything (including the 
> >> nsswitch modules), but otherwise that should work.
> >> 
> >
> > [ CC peter jones ]
> >
> > Ok, so even if we build kexec-tools statically with glibc, we have the
> > issue of name service switch modules. glibc will still do dlopen on
> > these modules. So what are options now.
> >
> > - Sign glibc and associated shared libraries. Do not allow unsigned
> >   shared library to dynamically link with signed executable.
> >
> > - Peter mentioned that work with uClibc for kexec-tools.
> >
> > I personally think that however hard it is but first option sounds like
> > a long term solution. We might have more user space processes which
> > we might have to trust a generic solution will help with that. For example,
> > we might have to sign and trust qemu at some point of time.
> >
> > Are there other ways of handing glibc issue?
> 
> It needs to be checked but /sbin/kexec should not use any functions that
> trigger nss switch.  No user or password or host name lookup should be
> happening.

I also think that we don't call routines which trigger nss switch but
be probably can't rely on that as somebody might introduce it in
future. So we need more robust mechanism to prevent it than just code
inspection.

> 
> This is one part in hardening /sbin/kexec to deal with hostile root
> users.  We need to check crazy things like do the files we open on /proc
> actually point to /proc after we have opened them.

Can you please explain it more. How can one fiddle with /proc. Also
what's the solution then.

> 
> I believe glibc has some code which triggers for suid root applications
> that we should ensure gets triggered that avoid trusting things like
> LD_LIBRARY_PATH and company.

I guess linking statically with uClibc or klibc (as hpa said), might turn
out to be better option to avoid all the issues w.r.t shared objects
and all the tricky environment variables.

Thanks
Vivek
