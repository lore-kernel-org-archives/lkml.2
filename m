Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1DUWp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:45:27 -0400
Received: from sous-sol.org ([216.99.217.87]:53350 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755544Ab1DUWp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:45:26 -0400
Date: Thu, 21 Apr 2011 15:44:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH RESEND 2] intel_iommu: disable all VT-d PMRs when TXT
 launched
Message-ID: <20110421224415.GG9569@sequoia.sous-sol.org>
References: <4D879328.1080006@intel.com>
 <4DB0AB00.80105@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB0AB00.80105@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joseph Cihula (joseph.cihula@intel.com) wrote:
> This patch detects when the kernel has been launched with TXT and then
> disables the PMRs on all VT-d engines.  In some cases where the reason
> that remapping is not being enabled is due to possible ACPI DMAR table
> errors, the VT-d engine addresses may not be correct and thus not able
> to be safely programmed even to disable PMRs.  Because part of the TXT
> launch process is the verification of these addresses, it will always be
> safe to disable PMRs if the TXT launch has succeeded and hence only
> doing this in such cases.

What about on resume?  The ->ignored units won't get PMR disabled.
