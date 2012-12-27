Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2L0XlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:41:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41806 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2L0XlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:41:14 -0500
MIME-Version: 1.0
Message-ID: <bd591d7e-5e78-4df1-af68-5c0e596a80f6@default>
Date: Thu, 27 Dec 2012 15:40:50 -0800 (PST)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <hpa@zytor.com>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <ebiederm@xmission.com>, <maxim.uvarov@oracle.com>,
        <andrew.cooper3@citrix.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <virtualization@lists.linux-foundation.org>,
        <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/26/2012 06:18 PM, Daniel Kiper wrote:
> > Hi,
> >
> > This set of patches contains initial kexec/kdump implementation for Xen v3.
> > Currently only dom0 is supported, however, almost all infrustructure
> > required for domU support is ready.
> >
> > Jan Beulich suggested to merge Xen x86 assembler code with baremetal x86 code.
> > This could simplify and reduce a bit size of kernel code. However, this solution
> > requires some changes in baremetal x86 code. First of all code which establishes
> > transition page table should be moved back from machine_kexec_$(BITS).c to
> > relocate_kernel_$(BITS).S. Another important thing which should be changed in that
> > case is format of page_list array. Xen kexec hypercall requires to alternate physical
> > addresses with virtual ones. These and other required stuff have not been done in that
> > version because I am not sure that solution will be accepted by kexec/kdump maintainers.
> > I hope that this email spark discussion about that topic.
>
> I want a detailed list of the constraints that this assumes and 
> therefore imposes on the native implementation as a result of this.  We 
> have had way too many patches where Xen PV hacks effectively nailgun 
> arbitrary, and sometimes poor, design decisions in place and now we 
> can't fix them.

OK but now I think that we should leave this discussion
until all details regarding kexec/kdump generic code
will be agreed. Sorry for that.

Daniel
