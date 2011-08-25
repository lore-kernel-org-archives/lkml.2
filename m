Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1HYXOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 19:14:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1HYXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 19:14:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4zojYjYVd=6U72ToqiZOD-qL-saP8huwa6ShrNnaR3vA@mail.gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com>
	<1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
	<CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com>
	<CAOfQC98Nkr7Ek3uQfiD3OdW=YC76XGjfQ4WSfoLpsm2kvqKnog@mail.gmail.com>
	<CAErSpo4zojYjYVd=6U72ToqiZOD-qL-saP8huwa6ShrNnaR3vA@mail.gmail.com>
Date: Fri, 26 Aug 2011 07:14:16 +0800
Message-ID: <CAOfQC9-kS_nVg-+2OZRGHP1X-E7B12uG63QGfB64hPAGecgFLw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource()
 to set up root resources
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/25 Bjorn Helgaas <bhelgaas@google.com>:
> No, I just mean that I don't see why you need this patch at all.  If
> you pass the list of bus resources to pci_create_bus(), there's no
> need to fix anything up later.  Or am I missing something?

Well, doing the root resource fixups in here is a *paranoid* way. It's to
deal with the 'unlikely' circumstance where controller_resources() returns
the NULL pointer in pcibios_scanbus() due to memory allocation failure.
Most of the time (always) it's nothing more than repeating the resource
list setup. But maybe we can do something like this:

if (unlikely(!dev && list_empty(&bus->resources))
        pcibios_setup_root_resources(bus, hose);


What do you think?


Deng-Cheng
