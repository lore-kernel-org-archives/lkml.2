Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1BYHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:33:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:12664 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1BYHdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:33:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,224,1297065600"; 
   d="scan'208";a="393927512"
From: "Tardy, Pierre" <pierre.tardy@intel.com>
To: Chris Ball <cjb@laptop.org>, Pierre Tardy <tardyp@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>
Date: Fri, 25 Feb 2011 07:33:12 +0000
Subject: RE: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Thread-Topic: [PATCH v2 2/3] sdhci-pci : Enable runtime PM support
Thread-Index: AcvSCF4BSMn11bkmRduy+bVWx73VaQCtSuFQ
Message-ID: <8250E4885F9967469CAC3FB5CBA2CE69935212DEA0@irsmsx501.ger.corp.intel.com>
References: <cover.1297014479.git.pierre.tardy@intel.com>
 <6722fa7986194808f4d69a1e5ba6d3f163b77da9.1297014479.git.pierre.tardy@intel.com>
 <20110210043718.GA7585@void.printf.net>
 <AANLkTi=iZ3dzAoRuRdpvQ=uBp4u8O8LtMuu2XdSWeZwr@mail.gmail.com>
 <20110221204523.GA28419@void.printf.net>
In-Reply-To: <20110221204523.GA28419@void.printf.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, 
Any comments here?

> It's getting enabled by drivers/pci/pci-driver.c:local_pci_probe(),
> before the sdhci-pci probe function runs.  local_pci_probe() does:
> 
>         /* Unbound PCI devices are always set to disabled and suspended.
>          * During probe, the device is set to enabled and active and the
>          * usage count is incremented.  If the driver supports runtime PM,
>          * it should call pm_runtime_put_noidle() in its probe routine and
>          * pm_runtime_get_noresume() in its remove routine.
>          */
>         pm_runtime_get_noresume(dev);
>         pm_runtime_set_active(dev);
>         pm_runtime_enable(dev);

OK. Sounds like it is a change post 2.6.37.
So we need to replace the current sdhci runtime_pm initialization by what is in this comments.

> > Maybe Rafael can advice on this.
> 
> The controller advertises the ability to generate PME wakeups from D3
> in its PCI capabilities; perhaps we just aren't programming it properly.
> I don't see anything in your patch that would set SDHCI wakeup bits or
> unmask card insertion/removal IRQs -- maybe that could be it?
My understanding is the pci driver is not supposed to do any set_power_state/pci_save_state/wake_enable.
Everything is supposed to be generically handle by pci frameworks's runtime_pm impl.
Need confirmation from Rafael.

Regards,
Pierre
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

