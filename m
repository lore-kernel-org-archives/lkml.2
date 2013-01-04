Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3ADTMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:12:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38876 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3ADTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:12:12 -0500
Date: Fri, 4 Jan 2013 14:11:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump
 implementation
Message-ID: <20130104191146.GC6721@phenom.dumpdata.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <50DBC856.6030208@zytor.com>
 <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
 <50DC58C4.3000307@citrix.com>
 <874nj7qsor.fsf@xmission.com>
 <50E41973.9050705@citrix.com>
 <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
 <50E6F81D02000078000B3245@nat28.tlf.novell.com>
 <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 06:07:51PM +0100, Daniel Kiper wrote:
> On Fri, Jan 04, 2013 at 02:41:17PM +0000, Jan Beulich wrote:
> > >>> On 04.01.13 at 15:22, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> > > On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
> > >> /sbin/kexec can load the "Xen" crash kernel itself by issuing
> > >> hypercalls using /dev/xen/privcmd.  This would remove the need for
> > >> the dom0 kernel to distinguish between loading a crash kernel for
> > >> itself and loading a kernel for Xen.
> > >>
> > >> Or is this just a silly idea complicating the matter?
> > >
> > > This is impossible with current Xen kexec/kdump interface.
> >
> > Why?
> 
> Because current KEXEC_CMD_kexec_load does not load kernel
> image and other things into Xen memory. It means that it
> should live somewhere in dom0 Linux kernel memory.

We could have a very simple hypercall which would have:

struct fancy_new_hypercall {
	xen_pfn_t payload; // IN
	ssize_t len; // IN
#define DATA (1<<1)
#define DATA_EOF (1<<2)
#define DATA_KERNEL (1<<3)
#define DATA_RAMDISK (1<<4)
	unsigned int flags; // IN
	unsigned int status; // OUT
};

which would in a loop just iterate over the payloads and
let the hypervisor stick it in the crashkernel space.

This is all hand-waving of course. There probably would be a need
to figure out how much space you have in the reserved Xen's
'crashkernel' memory region too.

> 
> Daniel
