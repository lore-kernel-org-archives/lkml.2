Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776Ab2KAOw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761621Ab2KAOwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:52:25 -0400
Date: Thu, 1 Nov 2012 10:51:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121101145149.GB15821@redhat.com>
References: <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
 <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
 <20121026170609.GB24687@redhat.com>
 <1351276649.18115.217.camel@falcor>
 <20121101131003.GA14573@redhat.com>
 <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351780159.15708.17.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 10:29:19AM -0400, Mimi Zohar wrote:
> On Thu, 2012-11-01 at 09:53 -0400, Vivek Goyal wrote:
> > On Thu, Nov 01, 2012 at 09:10:03AM -0400, Vivek Goyal wrote:
> > 
> > [..]
> > > > 
> > > > > - So say we can sign /sbin/kexec at build time and distros can do that.
> > > > > - Verify the signature at exec time using kernel keyring and if
> > > > >   verification happens successfully, say process gains extra capability.
> > > > > - Use this new capability to determine whether kexec_load() will be
> > > > >   successful or not.
> > > > > 
> > > > > Even if we can do all this, it still has the issue of being able to
> > > > > stop the process in user space and replace the code at run time
> > > > > and be able to launch unsigned kernel.
> > > 
> > > Thinking more about it. Can we just keep track whether a process was
> > > ptraced or not and disallow kexec_load() syscall if it was ptraced.
> > > (I am assuming that ptrace is the only way to change process code/data).
> > > 
> > > So binaries can be signed offline. Signature verification can take place
> > > using kernel keyring at exec() time. And we can keep track of ptraced
> > > processes and disallow calling kexec_load() for such processes. If this
> > > is implementable, this should take care of following requirement raised
> > > by matthew.
> > > 
> > > ************************************************************************
> > > It must be impossible for the kernel to launch any /sbin/kexec that hasn't
> > > been signed by a trusted key that's been built into the kernel, and it
> > > must be impossible for anything other than /sbin/kexec to make the kexec
> > > system call.
> > > *************************************************************************
> > > 
> > > Thoughts?
> > 
> > Eric responded but my mistake he responded to only me. So I will quickly 
> > put his idea here.
> > 
> > [start quote]
> > 
> > You can't ptrace a process that has a capability you don't.
> > 
> > That should be enforced in security/commoncap/
> > 
> > [end quote]
> > 
> > This looks like a good idea. Upon verification signed binaries will be
> > assigned special capability and then no unsigned binary should be able
> > to ptrace signed/verified processes
> 
> That's a good generic solution, which I'm all in favor of, but it
> doesn't resolve the latter half of Matthrew's requirement "and it must
> be impossible for anything other than /sbin/kexec to make the kexec
> system call."

I think what matthew might have meant that anything other than signed
trusted executable should not be able to call kexec_load(). Matthew?

And if one wants only /sbin/kexec to call it, then just sign that
one so no other executable will be able to call kexec_load(). Though
I don't think that's the requirement here. Requirement is that only
trusted executables should be able to call kexec_load().

Thanks
Vivek
