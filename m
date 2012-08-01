Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2HAQEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:04:44 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:56740 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2HAQEm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:04:42 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzz8275bhz2dh668h839h944hd25hf0ah107ah)
X-WSS-ID: 0M833BL-02-2EG-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Don Dutile <ddutile@redhat.com>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>, Jerome Glisse <jglisse@redhat.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v3 29/32] PCI/radeon: use PCIe capabilities access
 functions to simplify implementation
Thread-Topic: [PATCH v3 29/32] PCI/radeon: use PCIe capabilities access
 functions to simplify implementation
Thread-Index: AQHNb/7NQq3jl1LHFk6/1bH6YXoGCJdFHnkw
Date: Wed, 1 Aug 2012 16:04:35 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02234271D@sausexdag04.amd.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
 <1343836477-7287-30-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343836477-7287-30-git-send-email-jiang.liu@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.181.250.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jiang Liu [mailto:liuj97@gmail.com]
> Sent: Wednesday, August 01, 2012 11:55 AM
> To: Bjorn Helgaas; Don Dutile; David Airlie; Dave Airlie; Deucher, Alexander;
> Jerome Glisse
> Cc: Jiang Liu; Yinghai Lu; Taku Izumi; Rafael J . Wysocki; Kenji Kaneshige; Yijing
> Wang; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; Jiang Liu
> Subject: [PATCH v3 29/32] PCI/radeon: use PCIe capabilities access functions
> to simplify implementation
> 
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Use PCIe capabilities access functions to simplify radeon driver's
> implementation.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/evergreen.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/evergreen.c
> b/drivers/gpu/drm/radeon/evergreen.c
> index 01550d0..8804c80 100644
> --- a/drivers/gpu/drm/radeon/evergreen.c
> +++ b/drivers/gpu/drm/radeon/evergreen.c
> @@ -77,13 +77,9 @@ void evergreen_tiling_fields(unsigned tiling_flags,
> unsigned *bankw,
>  void evergreen_fix_pci_max_read_req_size(struct radeon_device *rdev)
>  {
>  	u16 ctl, v;
> -	int cap, err;
> +	int err;
> 
> -	cap = pci_pcie_cap(rdev->pdev);
> -	if (!cap)
> -		return;
> -
> -	err = pci_read_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL,
> &ctl);
> +	err = pci_pcie_capability_read_word(rdev->pdev, PCI_EXP_DEVCTL,
> &ctl);
>  	if (err)
>  		return;
> 
> @@ -95,7 +91,7 @@ void evergreen_fix_pci_max_read_req_size(struct
> radeon_device *rdev)
>  	if ((v == 0) || (v == 6) || (v == 7)) {
>  		ctl &= ~PCI_EXP_DEVCTL_READRQ;
>  		ctl |= (2 << 12);
> -		pci_write_config_word(rdev->pdev, cap + PCI_EXP_DEVCTL,
> ctl);
> +		pci_pcie_capability_write_word(rdev->pdev,
> PCI_EXP_DEVCTL, ctl);
>  	}
>  }
> 
> --
> 1.7.9.5
> 


