Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2LGSwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:52:20 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48484 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2LGSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:52:18 -0500
Message-ID: <50C23ADF.3060607@monstr.eu>
Date: Fri, 07 Dec 2012 19:52:15 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Michal Simek <michal.simek@xilinx.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        John Williams <jwilliams@xilinx.com>
Subject: Re: Sharing PCIE driver between Microblaze and Arm zynq
References: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com> <20121207131706.EC9273E0B87@localhost>
In-Reply-To: <20121207131706.EC9273E0B87@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:17 PM, Grant Likely wrote:
> On Thu, 6 Dec 2012 15:23:14 +0100, Michal Simek <michal.simek@xilinx.com> wrote:
>> Hi guys,
>>
>> I have a question regarding to sharing generic OF pcie driver between
>> two architectures MB and ARM Zynq.
>> Is drivers/pci/pcie location good for it?
>> Make no sense to have the same driver in two locations.
>> Is using readl/writel IO functions in this driver the best option
>> which we can have?
>> Or is there any other recommendation?

Grant: What do you think about readl/iowrite usage in connection to PCI?

>> Also just want to check if it is correct to use pcie device_type.
>> The rest should be the same with pci description:
>> (http://devicetree.org/MPC5200:PCI#PCI_Address_Translation).
>
> Yes. device_type may be deprecated, but the PCI binding predates that.

If it is deprecated, there could be probably problem with early_init_dt_scan_memory()
which is checking memory device_type (drivers/of/fdt.c).


> PowerPC uses pcie in the device type. arch/powerpc/kernel/of_platform.c

ok. I see.

> Some of that powerpc DT PCI support code really should be made generic.

yep.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
