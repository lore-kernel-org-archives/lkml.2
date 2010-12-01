Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0LAH2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:28:55 -0500
Received: from sous-sol.org ([216.99.217.87]:40869 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750735Ab0LAH2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:28:54 -0500
Date: Tue, 30 Nov 2010 23:26:54 -0800
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
Subject: Re: [patch 1/4] vt-d: quirk for masking vtd spec errors to platform
 error handling logic
Message-ID: <20101201072654.GL10050@sequoia.sous-sol.org>
References: <20101201062225.292364637@intel.com>
 <20101201062244.365995600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201062244.365995600@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> On platforms with Intel 7500 chipset, there were some reports of system
> hang/NMI's during kexec/kdump in the presence of interrupt-remapping enabled.
> 
> During kdump, there is a window where the devices might be still using old
> kernel's interrupt information, while the kdump kernel is coming up. This can
> cause vt-d faults as the interrupt configuration from the old kernel map to
> null IRTE entries in the new kernel etc. (with out interrupt-remapping enabled,
> we still have the same issue but in this case we will see benign spurious
> interrupt hit the new kernel).
> 
> Based on platform config settings, these platforms seem to generate NMI/SMI
> when a vt-d fault happens and there were reports that the resulting SMI causes
> the  system to hang.
> 
> Fix it by masking vt-d spec defined errors to platform error reporting logic.
> VT-d spec related errors are already handled by the VT-d OS code, so need to
> report the same erorr through other channels.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Chris Wright <chrisw@sous-sol.org>
