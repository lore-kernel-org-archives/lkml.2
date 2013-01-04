Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3ADRCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:02:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3ADRCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:02:12 -0500
Date: Fri, 4 Jan 2013 18:01:20 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130104170120.GA3472@host-192-168-1-59.local.net-space.pl>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <50DBC856.6030208@zytor.com>
 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
 <50DC58C4.3000307@citrix.com>
 <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
 <50E6E974.5090805@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E6E974.5090805@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 02:38:44PM +0000, David Vrabel wrote:
> On 04/01/13 14:22, Daniel Kiper wrote:
> > On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
> >> On 27/12/12 18:02, Eric W. Biederman wrote:
> >>> Andrew Cooper<andrew.cooper3@citrix.com>  writes:
> >>>
> >>>> On 27/12/2012 07:53, Eric W. Biederman wrote:
> >>>>> The syscall ABI still has the wrong semantics.
> >>>>>
> >>>>> Aka totally unmaintainable and umergeable.
> >>>>>
> >>>>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
> >>>> There are two requirements pulling at this patch series, but I agree
> >>>> that we need to clarify them.
> >>> It probably make sense to split them apart a little even.
> >>>
> >>>
> >>
> >> Thinking about this split, there might be a way to simply it even more.
> >>
> >> /sbin/kexec can load the "Xen" crash kernel itself by issuing
> >> hypercalls using /dev/xen/privcmd.  This would remove the need for
> >> the dom0 kernel to distinguish between loading a crash kernel for
> >> itself and loading a kernel for Xen.
> >>
> >> Or is this just a silly idea complicating the matter?
> >
> > This is impossible with current Xen kexec/kdump interface.
> > It should be changed to do that. However, I suppose that
> > Xen community would not be interested in such changes.
>
> I don't see why the hypercall ABI cannot be extended with new sub-ops
> that do the right thing -- the existing ABI is a bit weird.
>
> I plan to start prototyping something shortly (hopefully next week) for
> the Xen kexec case.

Wow... As I can this time Xen community is interested in...
That is great. I agree that current kexec interface is not ideal.

David, I am happy to help in that process. However, if you wish I could
carry it myself. Anyway, it looks that I should hold on with my
Linux kexec/kdump patches.

My .5 cents:
  - We should focus on KEXEC_CMD_kexec_load and KEXEC_CMD_kexec_unload;
    probably we should introduce KEXEC_CMD_kexec_load2 and KEXEC_CMD_kexec_unload2;
    load should __LOAD__ kernel image and other things into hypervisor memory;
    I suppose that allmost all things could be copied from linux/kernel/kexec.c,
    linux/arch/x86/kernel/{machine_kexec_$(BITS).c,relocate_kernel_$(BITS).c};
    I think that KEXEC_CMD_kexec should stay as is,
  - Hmmm... Now I think that we should still use kexec syscall to load image
    into Xen memory (with new KEXEC_CMD_kexec_load2) because it establishes
    all things which are needed to call kdump if dom0 crashes; however,
    I could be wrong...
  - last but not least, we should think about support for PV guests too.

Daniel
