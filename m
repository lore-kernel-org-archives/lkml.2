Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2KWLJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:09:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29481 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2KWLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:09:06 -0500
Date: Fri, 23 Nov 2012 12:08:08 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
Message-ID: <20121123110808.GA3002@host-192-168-1-59.local.net-space.pl>
References: <87lidwtego.fsf@xmission.com>
 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
 <87txshx28b.fsf@xmission.com>
 <50AE6542.3020302@zytor.com>
 <50AEBF86.50501@citrix.com>
 <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
 <50AED7B8.7040902@citrix.com>
 <50AF55B102000078000AABF3@nat28.tlf.novell.com>
 <20121123103726.GB2921@host-192-168-1-59.local.net-space.pl>
 <50AF635B02000078000AAD0C@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AF635B02000078000AAD0C@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 10:51:55AM +0000, Jan Beulich wrote:
> >>> On 23.11.12 at 11:37, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > On Fri, Nov 23, 2012 at 09:53:37AM +0000, Jan Beulich wrote:
> >> >>> On 23.11.12 at 02:56, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> >> > On 23/11/2012 01:38, H. Peter Anvin wrote:
> >> >> I still don't really get why it can't be isolated from dom0, which would
> >> > make more sense to me, even for a Xen crash.
> >> >>
> >> >
> >> > The crash region (as specified by crashkernel= on the Xen command line)
> >> > is isolated from dom0.
> >> >
> >> > dom0 (using the kexec utility etc) has the task of locating the Xen
> >> > crash notes (using the kexec hypercall interface), constructing a binary
> >> > blob containing kernel, initram and gubbins, and asking Xen to put this
> >> > blob in the crash region (again, using the kexec hypercall interface).
> >> >
> >> > I do not see how this is very much different from the native case
> >> > currently (although please correct me if I am misinformed).  Linux has
> >> > extra work to do by populating /proc/iomem with the Xen crash regions
> >> > boot (so the kexec utility can reference their physical addresses when
> >> > constructing the blob), and should just act as a conduit between the
> >> > kexec system call and the kexec hypercall to load the blob.
> >>
> >> But all of this _could_ be done completely independent of the
> >> Dom0 kernel's kexec infrastructure (i.e. fully from user space,
> >> invoking the necessary hypercalls through the privcmd driver).
> >
> > No, this is impossible. kexec/kdump image lives in dom0 kernel memory
> > until execution. That is why privcmd driver itself is not a solution
> > in this case.
>
> Even if so, there's no fundamental reason why that kernel image
> can't be put into Xen controlled space instead.

Yep, but we must change Xen kexec interface and/or its behavior first.
If we take that option then we could also move almost all needed things
from dom0 kernel to Xen. This way we could simplify Linux Kernel
kexec/kdump infrastructure needed to run on Xen.

Daniel
