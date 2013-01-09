Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3AIKbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:31:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:13723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3AIKbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:31:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,436,1355126400"; 
   d="scan'208";a="189235141"
Message-ID: <50ED4615.1040204@intel.com>
Date: Wed, 09 Jan 2013 10:27:33 +0000
From: Tadeusz Struk <tadeusz.struk@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Make pci_find_upstream_pcie_bridge() handle non
 PCIE VFs well
References: <50ec2e19.EUrQfXEnsRJiPCTv%tadeusz.struk@intel.com> <50EC51E3.6070306@redhat.com>
In-Reply-To: <50EC51E3.6070306@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 05:05 PM, Don Dutile wrote:

> (a) no such thing as a non-PCIe VF -- all VFs
>     are PCIe-based.

The sriov spec says that a VF doesn't necessarily has to have PCIE cap:
"3.5 PCI Express Capability:
   ...
   PFs and VFs are required to implement this capability ... subject to
   the exceptions and additional requirements described below"

> (b) code says to return null if VF doesn't have PCIe cap,
>     but the code checks if pdev is VF and if PF is PCIe,
>     which it must be! ...

You are right, I should rather check if the VF is not a pcie.

> nack until a better &/or matching explanation of what
> the real problem is, and what the solution is trying to do.

The problem is that I do have a device where VFs are not PCIE and I get this nasty warning.
For now I have a workaround, but it would be nice it Linux would support non PCIE VFs.

Thanks,
T

