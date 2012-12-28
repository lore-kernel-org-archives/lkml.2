Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2L1Axi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:53:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37465 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2L1Axg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:53:36 -0500
MIME-Version: 1.0
Message-ID: <45868bcd-baa9-4a4d-901f-23d1c35cebea@default>
Date: Thu, 27 Dec 2012 16:53:09 -0800 (PST)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <ebiederm@xmission.com>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <maxim.uvarov@oracle.com>, <andrew.cooper3@citrix.com>,
        <hpa@zytor.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <virtualization@lists.linux-foundation.org>,
        <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrew Cooper <andrew.cooper3@citrix.com> writes:
>
> > On 27/12/2012 07:53, Eric W. Biederman wrote:
> >> The syscall ABI still has the wrong semantics.
> >>
> >> Aka totally unmaintainable and umergeable.
> >>
> >> The concept of domU support is also strange.  What does domU support even mean, when the dom0 > support is loading a kernel to pick up Xen when Xen falls over.
> >
> > There are two requirements pulling at this patch series, but I agree
> > that we need to clarify them.
>
> It probably make sense to split them apart a little even.
>
> > When dom0 loads a crash kernel, it is loading one for Xen to use.  As a
> > dom0 crash causes a Xen crash, having dom0 set up a kdump kernel for
> > itself is completely useless.  This ability is present in "classic Xen
> > dom0" kernels, but the feature is currently missing in PVOPS.
>
> > Many cloud customers and service providers want the ability for a VM
> > administrator to be able to load a kdump/kexec kernel within a
> > domain[1].  This allows the VM administrator to take more proactive
> > steps to isolate the cause of a crash, the state of which is most likely
> > discarded while tearing down the domain.  The result being that as far
> > as Xen is concerned, the domain is still alive, while the kdump
> > kernel/environment can work its usual magic.  I am not aware of any
> > feature like this existing in the past.
>
> Which makes domU support semantically just the normal kexec/kdump
> support.  Got it.

To some extent. It is true on HVM and PVonHVM guests. However,
PV guests requires a bit different kexec/kdump implementation
than plain kexec/kdump. Proposed firmware support has almost
all required features. PV guest specific features (a few) will
be added later (after agreeing generic firmware support which
is sufficient at least for dom0).

It looks that I should replace domU by PV guest in patch description.

> The point of implementing domU is for those times when the hypervisor
> admin and the kernel admin are different.

Right.

> For domU support modifying or adding alternate versions of
> machine_kexec.c and relocate_kernel.S to add paravirtualization support
> make sense.

It is not sufficient. Please look above.

> There is the practical argument that for implementation efficiency of
> crash dumps it would be better if that support came from the hypervisor
> or the hypervisor environment.  But this gets into the practical reality

I am thinking about that.

> that the hypervisor environment does not do that today.  Furthermore
> kexec all by itself working in a paravirtualized environment under Xen
> makes sense.
>
> domU support is what Peter was worrying about for cleanliness, and
> we need some x86 backend ops there, and generally to be careful.

As I know we do not need any additional pv_ops stuff
if we place all needed things in kexec firmware support.

Daniel
