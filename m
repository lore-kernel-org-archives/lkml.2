Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2BBKBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:01:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34983 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2BBKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:01:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F2A5ED1.3040109@jp.fujitsu.com>
Date: Thu, 02 Feb 2012 19:00:49 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 0/7] PCI: pcie hotplug related patch
References: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1327690515-2991-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai, Jesse,

I tested pciehp with your set of patches. I have some comments below.

(1) I got a following warning message on compiling the patch [5/7].

     drivers/pci/hotplug/pciehp_hpc.c:281: warning: 'pcie_wait_link_not_active' defined but not used

(2) I got following warning messages on compiling the patch [6/7]

     drivers/pci/hotplug/pciehp_hpc.c:381: warning: 'pciehp_link_enable' defined but not used
     drivers/pci/hotplug/pciehp_hpc.c:386: warning: 'pciehp_link_disable' defined but not used

(3) I've asked Naoki Yanagimoto, who reported that configuration read
     on some hot-added PCIe device returns invalid value, to test the
     patch. Unfortunately, the problem happens with your patch. But
     after some discussion and testing, it turned out that problem doesn't
     happen when the same card with updated bios is used. So it seems the
     problem is in PCIe card side.

As a result, problems I found are (1) and (2). Please fix those.
Other than that, pciehp seems to work well.

Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Regards,
Kenji Kaneshige



(2012/01/28 3:55), Yinghai Lu wrote:
> 75e4615: pciehp: Disable/enable link during slot power off/on
> 92bdfaf: pciehp: Add Disable/enable link functions
> 47442c1: pciehp: Add pcie_wait_link_not_active()
> 40b6c9b: pciehp: print out link status when dlla get active.
> dcc66b6: pciehp: Checking pci conf reading to new added device instead of sleep 1s
> aadd74c: PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
> e7457be: PCI: Make sriov work with hotplug remove
>
>   drivers/pci/hotplug/pciehp_hpc.c |  133 +++++++++++++++++++++++++++++++-------
>   drivers/pci/pci.h                |    2 +
>   drivers/pci/probe.c              |   48 +++++++++-----
>   drivers/pci/remove.c             |   10 +++-
>   4 files changed, 151 insertions(+), 42 deletions(-)
>
> First one is for hotplug with sriov under bridge.
> following two are for hotplug probing with pci conf reading.
> Last four are for pcie link disable when power off slots.
>
> -v2: update first one according to reviewing from linus.
>       other like pci_dev_read_config return checking is not changed.
>
> Resending whole set according to Jesse.
>
> Thanks
>
> Yinghai Lu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

