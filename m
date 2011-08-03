Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1HCN4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:56:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33136 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1HCN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:56:25 -0400
Date: Wed, 3 Aug 2011 09:56:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@mit.edu>, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/6] Collected vdso/vsyscall fixes for 3.1
Message-ID: <20110803135604.GA29761@dumpdata.com>
References: <cover.1312378163.git.luto@mit.edu>
 <20110803135322.GC29501@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803135322.GC29501@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E39537E.00AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 09:53:22AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 03, 2011 at 09:31:48AM -0400, Andy Lutomirski wrote:
> > This fixes various problems that cropped up with the vdso patches.
> > 
> >  - Patch 1 fixes an information leak to userspace.
> >  - Patches 2 and 3 fix the kernel build on gold.
> >  - Patches 4 and 5 fix Xen (I hope).
> >  - Patch 6 (optional) adds a trace event to vsyscall emulation.  It will
> >    make it easier to handle performance regression reports :)
> 
> Hm, you seemed to have the x86 maintainers on your email..

I definitly need some coffee. What I meant was that you missing putting
the x86 maintainers on this patchset. They are the ones that will handle this.

I put them on the To list for you.
> > 
> > [1] https://gitorious.org/linux-test-utils/linux-clock-tests
> > 
> > Changes from v1:
> >  - Improve changelog message for "x86-64/xen: Enable the vvar mapping"
> >  - Fix 32-bit build.
> >  - Add patch 6.
> > 
> > Andy Lutomirski (6):
> >   x86-64: Pad vDSO to a page boundary
> >   x86-64: Move the "user" vsyscall segment out of the data segment.
> >   x86-64: Work around gold bug 13023
> >   x86-64/xen: Enable the vvar mapping
> >   x86-64: Add user_64bit_mode paravirt op
> >   x86-64: Add vsyscall:emulate_vsyscall trace event
> > 
> >  arch/x86/include/asm/desc.h           |    4 +-
> >  arch/x86/include/asm/paravirt_types.h |    6 ++++
> >  arch/x86/include/asm/ptrace.h         |   19 +++++++++++++
> >  arch/x86/kernel/paravirt.c            |    4 +++
> >  arch/x86/kernel/step.c                |    2 +-
> >  arch/x86/kernel/vmlinux.lds.S         |   46 ++++++++++++++++++---------------
> >  arch/x86/kernel/vsyscall_64.c         |   12 +++++---
> >  arch/x86/kernel/vsyscall_trace.h      |   29 ++++++++++++++++++++
> >  arch/x86/mm/fault.c                   |    2 +-
> >  arch/x86/vdso/vdso.S                  |    1 +
> >  arch/x86/xen/enlighten.c              |    4 +++
> >  arch/x86/xen/mmu.c                    |    4 ++-
> >  12 files changed, 102 insertions(+), 31 deletions(-)
> >  create mode 100644 arch/x86/kernel/vsyscall_trace.h
> > 
> > -- 
> > 1.7.6
