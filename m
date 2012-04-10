Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab2DJPRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:17:53 -0400
Received: from [124.207.24.138] ([124.207.24.138]:38998 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758869Ab2DJPRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:17:52 -0400
Subject: Re: [RFC PATCH] xen: get correct nr_irqs_gsi value from hypervisor
From: Lin Ming <mlin@ss.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>
In-Reply-To: <1334069838.5865.130.camel@hp6530s>
References: <1334069838.5865.130.camel@hp6530s>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 10 Apr 2012 23:16:35 +0800
Message-ID: <1334070995.5865.135.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 22:57 +0800, Lin Ming wrote:
> nr_irqs_gsi is set in probe_nr_irqs_gsi()
> 	nr_irqs_gsi = gsi_top + NR_IRQS_LEGACY;
> 
> gsi_top is set in mp_register_ioapic()
> 	gsi_top = gsi_cfg->gsi_end + 1;
> 
> mp_register_ioapic() calls io_apic_read, which don't have a Xen specific
> version. Actually, io_apic_read() always return -1 on Xen Dom0 kernel.
> 
> So currently, nr_irqs_gsi is always wrong on Xen Dom0 kernel.
> 
> This patch gets the correct nr_irqs_gsi value from Xen hypervisor with a
> hypercall.
> 
> Signed-off-by: Lin Ming <mlin@ss.pku.edu.cn>
> --
>  arch/x86/include/asm/io_apic.h  |    2 ++
>  arch/x86/kernel/apic/io_apic.c  |    2 +-
>  arch/x86/xen/setup.c            |    9 +++++++++
>  include/xen/interface/physdev.h |    6 ++++++
>  4 files changed, 18 insertions(+), 1 deletions(-)
> 
> (I will send xen hypervisor patch in another mail)\

Here is xen hypervisor side patch:

[RFC PATCH] x86: Add a new physdev_op PHYSDEVOP_nr_irqs_gsi
http://marc.info/?l=xen-devel&m=133407101003891&w=2

Regards,
Lin Ming

