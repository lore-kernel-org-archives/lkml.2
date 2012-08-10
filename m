Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2HJJdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:33:01 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:10738
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757952Ab2HJJc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:32:59 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M8J96U-01-07R-02
X-M-MSG: 
Date: Fri, 10 Aug 2012 11:32:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v3] irq_remap: disable IRQ remapping if any IOAPIC lacks
 an IOMMU
Message-ID: <20120810093250.GT1996@amd.com>
References: <CAE9FiQVEsPisVUKeG0aejKzvS+Csp5Ca2KEQyy6ZJW-MR-VFUA@mail.gmail.com>
 <1344432423-26495-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1344432423-26495-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 08:27:03AM -0500, Seth Forshee wrote:
> The ACPI tables in the Macbook Air 5,1 define a single IOAPIC with id 2,
> but the only remapping unit described in the DMAR table matches id 0.
> Interrupt remapping fails as a result, and the kernel panics with the
> message "timer doesn't work through Interrupt-remapped IO-APIC."
> 
> To fix this, check each IOAPIC for a corresponding IOMMU. If an IOMMU is
> not found, do not allow IRQ remapping to be enabled.
> 
> v2: Move check to parse_ioapics_under_ir(), raise log level to KERN_ERR,
>     and add FW_BUG to the log message
> v3: Skip check if IOMMU doesn't support interrupt remapping and remove
>     existing check that the IOMMU count equals the IOAPIC count
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/iommu/intel_irq_remapping.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

Applied to iommu/fixes, thanks.


