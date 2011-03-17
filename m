Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1CQATW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:19:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40094 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1CQATQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:19:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [RFT][PATCH] PCI / ACPI: Do not require MSI support for PCIe native features
Date: Thu, 17 Mar 2011 01:19:17 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
References: <201103052254.48515.rjw@sisk.pl> <201103150100.17501.rjw@sisk.pl> <20110315190545.GA4165@xanatos>
In-Reply-To: <20110315190545.GA4165@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103170119.17647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 15, 2011, Sarah Sharp wrote:
> On Tue, Mar 15, 2011 at 01:00:17AM +0100, Rafael J. Wysocki wrote:
> > Well, I must admit I have no idea what the problem is.  OK, in addition to the
> > above changes, please replace the "pci_ext_cfg_avail(root->bus->self)" in the
> > same file with "true" and see if _that_ helps.
> 
> Yay, that worked!  dmesg is attached.

Good, at least we know what the problem is, now we only have to find the root
cause. ;-)

So, pci_ext_cfg_avail(root->bus->self) returns 0 on your machine, which is kind
of unexpected (to put it lightly), so very likely we have uncovered a bug
in the init code.

Unfortunately, I may not be able to take care of this issue for the next few
days, I'll let you know when I get back to it.

Thanks,
Rafael
