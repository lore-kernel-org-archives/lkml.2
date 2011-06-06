Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1FFJJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:09:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51889 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab1FFJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WE8rC2RWeC+xSMjSfXntlaQevWqag95qX7MhZsp2xEOE4oS/Rb8Nrw2YMHlPfwFn/1
         7KyGl+YEJdTCLB+S4tKWZ/n4+iK8ovJ0mrrgNpka6C3nZnhe0V482DYhxwHrdGmXfps5
         Q/70axpzek4N+uprdPqvJIG+fa3B44cAWfNC4=
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 14:39:30 +0530
Message-ID: <BANLkTi=q0f8aYc2+fhaY5yFRRfgkOOME-g@mail.gmail.com>
Subject: Seeing DMAR errors after multiple load/unload with SR-IOV
From: padmanabh ratnakar <pratnakarlx@gmail.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
        I am using linux kernel 2.6.39. I have a IBM x3650 M3 system.
I have used following boot options -
intel_iommu=on iommu=pt

I was loading/unloading my NIC driver(be2net) with num_vfs=7.

After some iterations I get following DMAR errors -
Jun  4 03:50:20 rhel6 kernel: Uhhuh. NMI received for unknown reason
2d on CPU 0.
Jun  4 03:50:20 rhel6 kernel: Do you have a strange power saving mode enabled?
Jun  4 03:50:20 rhel6 kernel: Dazed and confused, but trying to continue
Jun  4 03:50:20 rhel6 kernel: DRHD: handling fault status reg 2
Jun  4 03:50:20 rhel6 kernel: DMAR:[DMA Read] Request device [1a:00.2]
fault addr 78077000
Jun  4 03:50:20 rhel6 kernel: DMAR:[fault reason 02] Present bit in
context entry is clear

I was trying to debug this. I dont understand iommu code much.
The physical address belongs the printed PCI function and there should
not have been an error.

I am unable to see pci_dev(pdev) of VFs getting removed from
si_domain->devices list(intel-iommu.c)
when driver gets unloaded calling pci_disable_sriov() freeing VF pdevs.
Looks like issue happens when when freed pdev is allocated again and
as it is already in list,
required initializations dont happen.

I dont know if my understanding is correct. Can anyone point me to
what the issue may be?

Thanks,
Padmanabh
