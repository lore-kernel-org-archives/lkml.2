Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1HDWk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:40:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18166 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1HDWku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:40:50 -0400
Date: Thu, 4 Aug 2011 18:40:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-next@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] Re: linux-next: Tree for July 25 (xen)
Message-ID: <20110804224020.GA21492@dumpdata.com>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
 <20110725144629.b752bf14.rdunlap@xenotime.net>
 <20110804193534.GB12729@elte.hu>
 <20110804195539.GA11198@dumpdata.com>
 <20110804131516.c4da6595.rdunlap@xenotime.net>
 <20110804223259.GB4370@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110804223259.GB4370@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E3B1FDD.0014:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 06:32:59PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > These build failures are still triggering upstream:
> > > > 
> > > >  arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
> > > >  arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
> > > >  arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
> > > >  arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
> > > >  arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)
> > > 
> > > Oh, that I haven't seen. Can you send me the .config for that please.
> > 
> > You can't be trying very hard then.  I see lots of these (but no,
> 
> Ah, I am getting it now. Thanks for reporting it.

This should do the trick:

diff --git a/arch/x86/xen/trace.c b/arch/x86/xen/trace.c
index 734beba..520022d 100644
--- a/arch/x86/xen/trace.c
+++ b/arch/x86/xen/trace.c
@@ -1,4 +1,5 @@
 #include <linux/ftrace.h>
+#include <xen/interface/xen.h>
 
 #define N(x)	[__HYPERVISOR_##x] = "("#x")"
 static const char *xen_hypercall_names[] = {
