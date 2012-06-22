Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2FVXKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:10:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab2FVXKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:10:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH -v6 0/4] PCIe, PM, Add PCIe runtime D3cold support
Date: Sat, 23 Jun 2012 01:15:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1340083249-16266-1-git-send-email-ying.huang@intel.com> <CAErSpo4Hd7__n=Ffxk5be1SwVbPZ5PdkaeX4sbAV886PCjSJtg@mail.gmail.com>
In-Reply-To: <CAErSpo4Hd7__n=Ffxk5be1SwVbPZ5PdkaeX4sbAV886PCjSJtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206230115.33210.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 23, 2012, Bjorn Helgaas wrote:
> On Mon, Jun 18, 2012 at 11:20 PM, Huang Ying <ying.huang@intel.com> wrote:
> > Changelog:
> >
> > v6:
> >
> > - Disable device D3cold during system suspend/hibernate with a new method per Rafeal's comments
> >
> > v5:
> >
> > - Disable device D3cold during system suspend/hibernate per Rafael's comments
> >
> > v4:
> >
> > - Minors fixes based on comments from Rafael
> >
> > v3:
> >
> > - Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
> > - Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
> > - Use black list instead of white list in pcie port runtime support per request from Bjorn
> > - Various fixes based on comments from Rafael
> >
> > v2:
> >
> > - Refreshed based on comments from Rafael
> >
> > [PATCH -v6 1/4] ACPI, PM, Specify lowest allowed state for device sleep
> > [PATCH -v6 2/4] PCIe, PM, Add runtime PM support to PCIe port
> > [PATCH -v6 3/4] PCI, PM, Do not call pci_set_power_state with PCI_D3cold
> > [PATCH -v6 4/4] PCIe, PM, Add PCIe runtime D3cold support
> 
> What kernel is this series based on?  Patch 4/4 doesn't apply to my
> tree.  This hunk fails because I don't have the "Some devices mustn't
> be in D3 ..." context:

I think it's based on an ACPI patch that didn't go in due to the problem
with the Len's tree.

Huang, can you please resend the series along with that patch?

Rafael


> @@ -1754,6 +1841,10 @@ int pci_prepare_to_sleep(struct pci_dev
>         if (target_state == PCI_POWER_ERROR)
>                 return -EIO;
> 
> +       /* D3cold during system suspend/hibernate is not supported */
> +       if (target_state > PCI_D3hot)
> +               target_state = PCI_D3hot;
> +
>         /* Some devices mustn't be in D3 during system sleep */
>         if (target_state == PCI_D3hot &&
>                         (dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP))
> 
> 

