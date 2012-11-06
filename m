Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2KFTeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 14:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2KFTeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 14:34:36 -0500
Date: Tue, 6 Nov 2012 14:34:19 -0500
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
Message-ID: <20121106193419.GH4548@redhat.com>
References: <1351276649.18115.217.camel@falcor>
 <20121101131003.GA14573@redhat.com>
 <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
 <20121101144304.GA15821@redhat.com>
 <20121101145225.GB10269@srcf.ucam.org>
 <20121102132318.GA3300@redhat.com>
 <87boffd727.fsf@xmission.com>
 <20121105180353.GC28720@redhat.com>
 <87mwyv96mn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwyv96mn.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:44:48AM -0800, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Fri, Nov 02, 2012 at 02:32:48PM -0700, Eric W. Biederman wrote:
> >> 
> >> It needs to be checked but /sbin/kexec should not use any functions that
> >> trigger nss switch.  No user or password or host name lookup should be
> >> happening.
> >
> > I also think that we don't call routines which trigger nss switch but
> > be probably can't rely on that as somebody might introduce it in
> > future. So we need more robust mechanism to prevent it than just code
> > inspection.
> 
> The fact that we shouldn't use those routines is enough to let us
> walk down a path where they are not used.  Either with a static glibc
> linked told to use no nss modules (--enable-static-nss ?), or with
> another more restricted libc.

I installed glibc-static and built kexec-tools using gcc "-static" option.
It built just fine and infact kdump is working with it.

Size of new kexec binary is around 1.4MB.

Did not get any warning w.r.t nss, so I am assuming we are not calling
any relevant functions.

I did try building my own libc using --enable-static-nss but it does not
seem to have built static versions of libnss*. Will look more into it
and try linking kexec with this new glibc and see if that works.

Also tried playing with klibc and uclibc a bit but can't get anything
going quickly.

Thanks
Vivek
