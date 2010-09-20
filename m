Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab0ITWbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:31:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:43625 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0ITWbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:31:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,395,1280732400"; 
   d="scan'208";a="556420443"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Tony Jones <tonyj@suse.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bphilips@suse.de" <bphilips@suse.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Mon, 20 Sep 2010 15:31:32 -0700
Subject: RE: high latency on 82573L
Thread-Topic: high latency on 82573L
Thread-Index: ActPgqJ4XtwxqV1BRF60dmQQSSK7TgJkEurQ
Message-ID: <8DD2590731AB5D4C9DBF71A877482A9001691E8C45@orsmsx509.amr.corp.intel.com>
References: <20100902033900.GA5283@suse.de>
	<8DD2590731AB5D4C9DBF71A877482A900168E59EFA@orsmsx509.amr.corp.intel.com>
	<20100903175102.GA7767@suse.de>
	<8DD2590731AB5D4C9DBF71A877482A900168EDB454@orsmsx509.amr.corp.intel.com>
 <20100908112104.33219331@jbarnes-desktop>
In-Reply-To: <20100908112104.33219331@jbarnes-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010 11:21 AM, Jesse Barnes wrote:
> On Fri, 3 Sep 2010 11:59:30 -0700
> "Allan, Bruce W" <bruce.w.allan@intel.com> wrote:
> 
>> ASPM L1 must be disabled on this device otherwise the latency
>> described above will happen.  And even though there are log messages
>> indicating ASPM L1 is disabled, it really isn't according to the
>> verbose lspci output and PCI config space for the 2:0.0 device (see
>> LnkCtl above). Since CONFIG_PCIEASPM is enabled in your kernel
>> config, the driver is calling the kernel function
>> pci_disable_link_state() to disable ASPM L1 which it fails to do
>> because the variable aspm_disabled=1 (as indicated by the "ACPI FADT
>> declares the system doesn't support PCIe ASPM, so disable it"
>> message).  
>> 
>> I'm unclear on whether the aspm_disabled variable is meant to
>> indicate ASPM L0s or both ASPM L0s _and_ L1 are disabled (added PCI
>> maintainer and linux-pci mail-list).  To resolve this issue, we need
>> to either a) change e1000e to directly write the PCI config space to
>> disable ASPM L1 as was done before 6f461f6c7c, or b) fix
>> pci_disable_link_state() et. al. to allow for ASPM L1 to be disabled
>> properly.  I would prefer the latter option so that other drivers do
>> not have to use the same kludge to write to the PCI config space. 
>> Any input from the PCI guys? 
> 
> Yeah, I'd prefer this code to be in the core.  Are there any patches
> available yet?

Nothing from me at this point (been on vacation).  I might be able to
look into this further but not for another week or so (need to catch
up on the backlog that piled up while away).

Bruce.
