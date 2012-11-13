Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2KMNiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:38:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54204 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2KMNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:38:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
References: <201211081915083774239@gmail.com>
	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
	<CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
	<CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
Date: Tue, 13 Nov 2012 21:38:05 +0800
Message-ID: <CANmqhJAjwP8CLEKpgsDbT-7+n=hf30LbYrTAu+qDH09LzETD4g@mail.gmail.com>
Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources for SR-IOV)
From: Jason Gao <pkill.2012@gmail.com>
To: bhelgaas@google.com, "Rose, Gregory V" <gregory.v.rose@intel.com>,
        sibai.li@intel.com
Cc: ddutile@redhat.com, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm very sorry for delayed reply.now SR-IOV works for me in Centos
6.3,thank all of you.


On Fri, Nov 9, 2012 at 11:26 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Linux normally uses the resource assignments done by the BIOS, but it
> is possible for the kernel to reassign those.  We don't have good
> automatic support for that yet, but on a recent upstream kernel, you
> can try "pci=realloc".  I doubt this option is in CentOS 6.3, though

Thank you very much,I try "pci=realloc" in Centos 6.3,and now it works for me.



On Sat, Nov 10, 2012 at 2:08 AM, Li, Sibai <sibai.li@intel.com> wrote:
> DellR710 with the latest BIOS should work fine for SR-IOV. My BIOS is v.6.3.0 and release date is 07/24/2012
> Please check if you configured intel_iommu=on in the grub.conf file.
> If you did, check your kernel .config file under Device Drivers-> IOMMU Hardware support->enable Support for Intel IOMMU using DMA remapping Devices, enable Intel DMA Remapping Devices by Default, enable Support for Interrupt Remapping.

thank you Sibai,Our server "Dell R710",its BIOS version is just
v.6.3.0 and release date is 07/24/2012,and I also configured
intel_iommu=on in the grub.conf file,but I can't find these IOMMU
options in "Device Drivers" in my kernel(2.6.32-279) .config file ,
btw my os is Centos 6.3(RHEL6.3),although the problem solved,I'd like
to know what's your os version ,kernel version?
