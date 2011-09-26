Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1IZMW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:22:26 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:14725
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205Ab1IZMWZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:22:25 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LS4QD1-01-5SH-02
X-M-MSG: 
Date: Mon, 26 Sep 2011 14:22:14 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of
 register_iommu
Message-ID: <20110926122213.GC2138@amd.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbZKa2orya_ijJ3vBeyERN2FYCKaSyn8gs=qsqJRC=kbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 03:09:58AM -0400, Ohad Ben-Cohen wrote:
> On Fri, Sep 23, 2011 at 6:45 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > -       register_iommu(&omap_iommu_ops);
> > +       bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
> 
> I'm not sure it makes a lot of sense to bind the iommu ops to the platform bus.
> 
> Unlike the pci bus, the platform bus is not really a hardware bus:
> it's some kind of a catch-all pseudo bus which is mostly used to to
> describe a collection of autonomous peripherals on an SoC.
> 
> As a result, IOMMU users on an SoC might actually not belong to the
> platform bus.

That is interesting. What bus do these IOMMU users you talk about belong
to?
Is it a seperate bus that originates from a platform device? in that
case the situation sounds a little bit like with USB on x86. The usb
controlers are PCI devices and DMA handles are allocated using the
pci_dev of the controler and not the usb_device.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

