Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2KMQE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:04:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:55370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2KMQE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:04:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,767,1344236400"; 
   d="scan'208";a="248442354"
From: "Li, Sibai" <sibai.li@intel.com>
To: Jason Gao <pkill.2012@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>
CC: "ddutile@redhat.com" <ddutile@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: RE: SR-IOV problem with Intel 82599EB (not enough MMIO resources
 for SR-IOV)
Thread-Topic: SR-IOV problem with Intel 82599EB (not enough MMIO resources
 for SR-IOV)
Thread-Index: AQHNwaQeM2H6P7Nnnk6rGhmSIf66+Jfn7aEQ
Date: Tue, 13 Nov 2012 16:04:53 +0000
Message-ID: <A3A921390EAE4044940E99EBF13D97321AE21E15@FMSMSX104.amr.corp.intel.com>
References: <201211081915083774239@gmail.com>	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
	<CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
	<CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
 <CANmqhJAjwP8CLEKpgsDbT-7+n=hf30LbYrTAu+qDH09LzETD4g@mail.gmail.com>
In-Reply-To: <CANmqhJAjwP8CLEKpgsDbT-7+n=hf30LbYrTAu+qDH09LzETD4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Gao [mailto:pkill.2012@gmail.com]
> Sent: Tuesday, November 13, 2012 5:38 AM
> To: bhelgaas@google.com; Rose, Gregory V; Li, Sibai
> Cc: ddutile@redhat.com; Kirsher, Jeffrey T; linux-kernel; netdev; kvm; e1000-
> devel@lists.sourceforge.net; linux-pci@vger.kernel.org; Yinghai Lu
> Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources
> for SR-IOV)
> 
> I'm very sorry for delayed reply.now SR-IOV works for me in Centos 6.3,thank all
> of you.
> 
> 
> On Fri, Nov 9, 2012 at 11:26 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > Linux normally uses the resource assignments done by the BIOS, but it
> > is possible for the kernel to reassign those.  We don't have good
> > automatic support for that yet, but on a recent upstream kernel, you
> > can try "pci=realloc".  I doubt this option is in CentOS 6.3, though
> 
> Thank you very much,I try "pci=realloc" in Centos 6.3,and now it works for me.
> 
> 
> 
> On Sat, Nov 10, 2012 at 2:08 AM, Li, Sibai <sibai.li@intel.com> wrote:
> > DellR710 with the latest BIOS should work fine for SR-IOV. My BIOS is
> > v.6.3.0 and release date is 07/24/2012 Please check if you configured
> intel_iommu=on in the grub.conf file.
> > If you did, check your kernel .config file under Device Drivers-> IOMMU
> Hardware support->enable Support for Intel IOMMU using DMA remapping
> Devices, enable Intel DMA Remapping Devices by Default, enable Support for
> Interrupt Remapping.
> 
> thank you Sibai,Our server "Dell R710",its BIOS version is just
> v.6.3.0 and release date is 07/24/2012,and I also configured intel_iommu=on in
> the grub.conf file,but I can't find these IOMMU options in "Device Drivers" in my
> kernel(2.6.32-279) .config file , btw my os is Centos 6.3(RHEL6.3),although the
> problem solved,I'd like to know what's your os version ,kernel version?

I am using RHEL6.3 with unstable kernel 3.7.0-rc
