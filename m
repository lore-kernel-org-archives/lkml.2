Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2KWLOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:14:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42717 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2KWLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:14:09 -0500
Date: Fri, 23 Nov 2012 12:13:08 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH v2 01/11] kexec: introduce kexec_ops struct
Message-ID: <20121123111308.GB3002@host-192-168-1-59.local.net-space.pl>
References: <87lidwtego.fsf@xmission.com>
 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
 <87txshx28b.fsf@xmission.com>
 <50AE6542.3020302@zytor.com>
 <50AEBF86.50501@citrix.com>
 <18e831d4-910d-4f58-8911-1398b96e3a47@email.android.com>
 <50AED7B8.7040902@citrix.com>
 <50AF55B102000078000AABF3@nat28.tlf.novell.com>
 <20121123103726.GB2921@host-192-168-1-59.local.net-space.pl>
 <1353667868.13542.218.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353667868.13542.218.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 10:51:08AM +0000, Ian Campbell wrote:
> On Fri, 2012-11-23 at 10:37 +0000, Daniel Kiper wrote:
> > On Fri, Nov 23, 2012 at 09:53:37AM +0000, Jan Beulich wrote:
> > > >>> On 23.11.12 at 02:56, Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> > > > The crash region (as specified by crashkernel= on the Xen command line)
> > > > is isolated from dom0.
> > > >[...]
> > >
> > > But all of this _could_ be done completely independent of the
> > > Dom0 kernel's kexec infrastructure (i.e. fully from user space,
> > > invoking the necessary hypercalls through the privcmd driver).
> >
> > No, this is impossible. kexec/kdump image lives in dom0 kernel memory
> > until execution.
>
> Are you sure? I could have sworn they lived in the hypervisor owned
> memory set aside by the crashkernel= parameter as Andy suggested.

I am sure. It is moved to final resting place when
relocate_kernel() is called by hypervisor.

Daniel
