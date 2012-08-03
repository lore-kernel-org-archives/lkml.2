Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2HCNuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:50:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30271 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2HCNuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:50:12 -0400
MIME-Version: 1.0
Message-ID: <9f903175-4080-4016-b9f8-83e8615c110e@default>
Date: Fri, 3 Aug 2012 06:49:59 -0700 (PDT)
From: Konrad Wilk <konrad.wilk@oracle.com>
To: <xhejtman@ics.muni.cz>
Cc: <yinghai@kernel.org>, <linux-pci@vger.kernel.org>, <roland@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: mellanox mlx4_core and SR-IOV
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about top-posting, using an webemail client.

This looks like you are using PV PCI passthrough? If so, did you
remember to use 'iommu=soft' to enable the Xen-SWIOTLB in your guest?
And are you booting with more than 4GB? Or is less than 3GB (so that you have
a nice gap in E820).

----- Original Message -----
From: xhejtman@ics.muni.cz
To: yinghai@kernel.org
Cc: roland@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Sent: Friday, August 3, 2012 4:34:03 AM GMT -05:00 US/Canada Eastern
Subject: Re: mellanox mlx4_core and SR-IOV

On Wed, Aug 01, 2012 at 04:36:14PM -0700, Yinghai Lu wrote:
> > so it seems, that pic=nocsr is a must now.
> 
> yes. Or you have bios provide SRIOV support or 64 bit resource in _CRS.

Well, I can use PCI passthrough in Xen now, however, it seems SR-IOV does not
work in case of Mellanox mlx4 driver.

With 3.5 stock kernel, I got this message in virtual domain:
[    2.666623] mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
[    2.666635] mlx4_core: Initializing 0000:00:00.1
[    2.666717] mlx4_core 0000:00:00.1: enabling device (0000 -> 0002)
[    2.666975] mlx4_core 0000:00:00.1: Xen PCI mapped GSI0 to IRQ168
[    2.667040] mlx4_core 0000:00:00.1: enabling bus mastering
[    2.667184] mlx4_core 0000:00:00.1: Detected virtual function - running in slave mode
[    2.667214] mlx4_core 0000:00:00.1: Sending reset
[    2.667319] mlx4_core 0000:00:00.1: Sending vhcr0
[    2.667886] mlx4_core 0000:00:00.1: HCA minimum page size:1
[    2.668067] mlx4_core 0000:00:00.1: The host doesn't support eth interface
[    2.668074] mlx4_core 0000:00:00.1: QUERY_FUNC_CAP command failed, aborting.
[    2.668079] mlx4_core 0000:00:00.1: Failed to obtain slave caps
[    2.668305] mlx4_core: probe of 0000:00:00.1 failed with error -93

not sure what does it mean.

I also tried OFED package from Mellanox which seems to have better SR-IOV
support (at least mlx4_ib does not complain that SR-IOV is not supported).
However, it does not work when SR-IOV enabled:
[13677.034266] mlx4_core 0000:02:00.0: Running in master mode
[13689.278238] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
[13689.278324] mlx4_core 0000:02:00.0: NOP command failed to generate MSI-X interrupt IRQ 241).
[13689.278399] mlx4_core 0000:02:00.0: Trying again without MSI-X.
[13699.286473] mlx4_core 0000:02:00.0: command 0x31 timed out (go bit not cleared)
[13699.286557] mlx4_core 0000:02:00.0: NOP command failed to generate interrupt (IRQ 237), aborting.
[13699.286633] mlx4_core 0000:02:00.0: BIOS or ACPI interrupt routing problem?
[13701.406680] mlx4_core: probe of 0000:02:00.0 failed with error -16

if I disable SR-IOV mode for this driver, it works OK. Could the interrupt
problem be BIOS related? I.e., it won't work until I got BIOS which properly
supports SR-IOV with Mellanox card?

-- 
Lukáš Hejtmánek
--
To unsubscribe from this list: send the line "unsubscribe linux-pci" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
