Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2FVWNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:13:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52790 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2FVWN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <1340083249-16266-1-git-send-email-ying.huang@intel.com>
References: <1340083249-16266-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 22 Jun 2012 16:13:05 -0600
Message-ID: <CAErSpo4Hd7__n=Ffxk5be1SwVbPZ5PdkaeX4sbAV886PCjSJtg@mail.gmail.com>
Subject: Re: [PATCH -v6 0/4] PCIe, PM, Add PCIe runtime D3cold support
To: Huang Ying <ying.huang@intel.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:20 PM, Huang Ying <ying.huang@intel.com> wrote:
> Changelog:
>
> v6:
>
> - Disable device D3cold during system suspend/hibernate with a new method per Rafeal's comments
>
> v5:
>
> - Disable device D3cold during system suspend/hibernate per Rafael's comments
>
> v4:
>
> - Minors fixes based on comments from Rafael
>
> v3:
>
> - Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
> - Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
> - Use black list instead of white list in pcie port runtime support per request from Bjorn
> - Various fixes based on comments from Rafael
>
> v2:
>
> - Refreshed based on comments from Rafael
>
> [PATCH -v6 1/4] ACPI, PM, Specify lowest allowed state for device sleep
> [PATCH -v6 2/4] PCIe, PM, Add runtime PM support to PCIe port
> [PATCH -v6 3/4] PCI, PM, Do not call pci_set_power_state with PCI_D3cold
> [PATCH -v6 4/4] PCIe, PM, Add PCIe runtime D3cold support

What kernel is this series based on?  Patch 4/4 doesn't apply to my
tree.  This hunk fails because I don't have the "Some devices mustn't
be in D3 ..." context:

@@ -1754,6 +1841,10 @@ int pci_prepare_to_sleep(struct pci_dev
        if (target_state == PCI_POWER_ERROR)
                return -EIO;

+       /* D3cold during system suspend/hibernate is not supported */
+       if (target_state > PCI_D3hot)
+               target_state = PCI_D3hot;
+
        /* Some devices mustn't be in D3 during system sleep */
        if (target_state == PCI_D3hot &&
                        (dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
