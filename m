Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1JaOIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 10:08:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28509 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1JaOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 10:08:50 -0400
Date: Mon, 31 Oct 2011 10:08:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Heinlein <theinlein@vandium.net>, 2013pfoley@tjhsst.edu
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Xen dom0 linux kernel 3.1 boot failure ptwr_emulate: could not
 get_page_from_l1e
Message-ID: <20111031140836.GA9245@phenom.dumpdata.com>
References: <05c3da5dc6158197e28d62e853ac2f04@tjhsst.edu>
 <loom.20111031T140651-901@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20111031T140651-901@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EAEABEE.00DB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 01:17:09PM +0000, Tobias Heinlein wrote:
> Hi,
> 
> 2013pfoley <2013pfoley <at> tjhsst.edu> writes:
> > [..]
> >
> >  [    0.000000] last_pfn = 0x63b5ef max_arch_pfn = 0x400000000
> >  [    0.000000] last_pfn = 0xdf62d max_arch_pfn = 0x400000000
> >  [    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
> >  (XEN) mm.c:945:d0 Error getting mfn 100 (pfn 5555555555555555) from L1 
> >  entry 8000000000100461 for l1e_owner=0, pg_owner=0
> >  (XEN) mm.c:5046:d0 ptwr_emulate: could not get_page_from_l1e()
> >  [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 
> >           (null)
> >  [    0.000000] IP: [<ffffffff81008a5a>] xen_set_pte+0x3a/0x1f0
> >  [    0.000000] PGD 0
> >  [    0.000000] Oops: 0003 [#1] SMP
> >  [    0.000000] CPU 0
> >  [    0.000000] Modules linked in:
> >  [    0.000000]
> >  [    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0 #4 HP ProLiant 
> >  DL380 G6
> 
> I get the exact same error here. Reading from your output, it seems we have the
> same hardware; I have this problem on a HP ProLiant DL380 G6, too. 
> 
> After a wild hint from a guy on ##xen to play around with the BIOS settings, I
> was able to narrow down the problem to a setting called "MPS Table Mode". It is
> set to "Full Table APIC" by default (with which the crash occurs), but when it's
> set to "Disabled" Xen boots the kernel just fine.
> 
> FWIW, the help text of the setting is: "Multi Processor Specification (MPS)
> Table / APIC Setting is used for interrupt routing. Certain unsupported
> operating systems may require setting the MPS Table Mode to APIC Disabled."

Oh nice. What does you /proc/interrupts look like compared to baremetal?

> 
> (BTW, the kernel itself boots fine without Xen. So I'm not sure if this belongs
> to the LKML at all.)

It does not. But CC-ing xen-devel here for further tracking.
