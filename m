Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2KBNXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab2KBNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:23:38 -0400
Date: Fri, 2 Nov 2012 09:23:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
Subject: Re: Kdump with signed images
Message-ID: <20121102132318.GA3300@redhat.com>
References: <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
 <20121026170609.GB24687@redhat.com>
 <1351276649.18115.217.camel@falcor>
 <20121101131003.GA14573@redhat.com>
 <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
 <20121101144304.GA15821@redhat.com>
 <20121101145225.GB10269@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101145225.GB10269@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 02:52:25PM +0000, Matthew Garrett wrote:
> On Thu, Nov 01, 2012 at 10:43:04AM -0400, Vivek Goyal wrote:
> 
> > So I think this does satisfy the requirement matthew specified. Isn't it?
> > Matthew, what do you think?
> 
> Sure, if you can ensure that. You'll need to figure out how to get the 
> build system to sign the userspace binaries and you'll need to ensure 
> that they're statically linked and don't dlopen anything (including the 
> nsswitch modules), but otherwise that should work.
> 

[ CC peter jones ]

Ok, so even if we build kexec-tools statically with glibc, we have the
issue of name service switch modules. glibc will still do dlopen on
these modules. So what are options now.

- Sign glibc and associated shared libraries. Do not allow unsigned
  shared library to dynamically link with signed executable.

- Peter mentioned that work with uClibc for kexec-tools.

I personally think that however hard it is but first option sounds like
a long term solution. We might have more user space processes which
we might have to trust a generic solution will help with that. For example,
we might have to sign and trust qemu at some point of time.

Are there other ways of handing glibc issue?

Thanks
Vivek
