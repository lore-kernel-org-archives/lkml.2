Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0FHUlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:41:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:45357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0FHUlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:41:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,386,1272870000"; 
   d="scan'208";a="805989946"
Date: Tue, 8 Jun 2010 13:41:23 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Alan Cox <alan@linux.intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] x86/sfi: fix ioapic gsi range
Message-ID: <20100608134123.6d9a6fb6@jacob-laptop>
In-Reply-To: <m1631tfh1i.fsf@fess.ebiederm.org>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org>
	<20100607225010.342e2fab@jacob-laptop>
	<m1631tfh1i.fsf@fess.ebiederm.org>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010 12:41:45 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:


> Even if sfi is never implemented on a platform where that kind of
> hardware exists, the current sfi code is setup to coexist
> simultaneously in the kernel with all of the infrastructure of other
> platforms where those kinds of devices exist.  Which means there can
> be drivers compiled into your kernel that make assumptions about
> special properties of the irqs 0-15.
> 
SFI code can be compiled in with ACPI at the same time but at runtime
there is only one used, ACPI take precedence. So there wouldn't be any
additional conflict caused by SFI added APIC tables.

> As for the question about using legacy_pic to detect the absence of
> an irq controller that Peter raised.  We can't do that because it
> should be possible for an acpi system with all of the legacy hardware
> to exist without needing to implement an i8259, or ever run in the
> historical interrupt delivery mode of pcs.
In your case, I don't understand how would it change the calculation of
irq mapping. Even if you don't use i8259 on a x86 PC platform, you
still have NR_LEGACY_IRQS=legacy_pic->nr_legacy_irqs.

On the other side, use NR_LEGACY_IRQS breaks the existing code for
Moorestown in terms of irq-gsi lookup and nr_irqs_gsi.
