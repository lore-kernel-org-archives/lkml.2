Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0LAIwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:52:38 -0500
Received: from sous-sol.org ([216.99.217.87]:49836 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751993Ab0LAIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:52:38 -0500
Date: Wed, 1 Dec 2010 00:51:52 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@kernel.org
Subject: Re: [patch 3/4] x86: enable the intr-remap fault handling after
 local apic setup
Message-ID: <20101201085152.GM10050@sequoia.sous-sol.org>
References: <20101201062225.292364637@intel.com>
 <20101201062244.541996375@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201062244.541996375@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Subject: x86: enable the intr-remap fault handling after local apic setup
> 
> Interrupt-remapping gets enabled very early in the boot, as it determines the
> apic mode that the processor can use. And the current code enables the vt-d
> fault handling before the setup_local_APIC(). And hence the APIC LDR registers
> and data structure in the memory may not be initialized. So the vt-d fault
> handling in logical xapic/x2apic modes were broken.
> 
> Fix this by enabling the vt-d fault handling in the end_local_APIC_setup()
> 
> A cleaner fix of enabling fault handling while enabling intr-remapping
> will be addressed for v2.6.38. [ Enabling intr-remapping determines the
> usage of x2apic mode and the apic mode determines the fault-handling
> configuration. ]
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
