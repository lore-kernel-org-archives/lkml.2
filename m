Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0HQQpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:45:38 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:48564 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530Ab0HQQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:45:33 -0400
Subject: Re: [Patch] Skip cpu_calibrate for kernel running under
	hypervisors.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@amd.com" <borislav.petkov@amd.com>
In-Reply-To: <20100817070520.GD32714@liondog.tnic>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
	 <4C69D02F.6090601@zytor.com>
	 <1282024311.20786.2.camel@ank32.eng.vmware.com>
	 <4C6A2C98.4060605@zytor.com>  <20100817070520.GD32714@liondog.tnic>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 17 Aug 2010 09:45:32 -0700
Message-Id: <1282063532.4388.8.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Tue, 2010-08-17 at 00:05 -0700, Borislav Petkov wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Mon, Aug 16, 2010 at 11:30:48PM -0700
> 
> > On 08/16/2010 10:51 PM, Alok Kataria wrote:
> > >>
> > >> I'm somewhat reluctant to take this one, since it assumes all the
> > >> hypervisors act the same.  This seems rather inherently wrong.  In fact,
> > >> the whole statement is fishy as heck... instead of being dependent on
> > >> AMD and so on, 
> > > 
> > > The check about being on AMD is something that was already there. 
> > > 
> > 
> > I know it was... and calibrate_cpu() seems to be an AMD-specific
> > function, but that's rather crappy.  I'm thinking that perhaps we should
> > make it an x86_init function, then the AMD CPU detection can install it
> > and the vmware hypervisor detection can uninstall it.
> 
> Btw, can we revisit this AMD-specific issue? IIUC, Alok you're seeing
> a mismatch between the calibrated TSC value and the cpu frequency even
> on cpus which have the CONSTANT_TSC bit set, i.e. their TSC is counting
> with P0 frequency. Can you please elaborate more on what systems you're
> seeing this (cpu family, chipset, etc)?

We have seen these issues when running inside a Virtual Machine on
VMware's platform. Please look at the vmware_set_cpu_features function,
it relies on the hypervisor to provide a constant/reliable TSC. Though
still when running the kernel on virtual cpus, as compared to
running on physical cpus, the timing characteristics are different,
since virtual cpus have to time share physical cpus with each other,
which may result in errors during calibration. As a result its better to
get these values directly from the hypervisor rather than trying to
calibrate them.

And just to clarify, we have never seen this on a physical machine.

Thanks,
Alok


> 
> Thanks.
> 

