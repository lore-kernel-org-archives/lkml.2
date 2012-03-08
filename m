Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab2CHWuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:50:14 -0500
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:35464 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab2CHWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:50:12 -0500
Message-ID: <4F593792.1070909@genband.com>
Date: Thu, 08 Mar 2012 16:49:54 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: Re: trying to figure out why VT-d isn't working on my kernel -- solved
References: <4F56E728.8020506@genband.com>
In-Reply-To: <4F56E728.8020506@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2012 22:49:55.0183 (UTC) FILETIME=[C7CE57F0:01CCFD7D]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18762.002
X-TM-AS-Result: No--18.768000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 10:42 PM, Chris Friesen wrote:
> Hi,
>
> I've got a current (pulled today) kernel running on a Xeon E5-2648L CPU
> on an Intel motherboard, and I'm trying to get VT-d working without much success.
>
> lspci -vv (version 3.1.4) doesn't show anything related to IOV.
> (Full output below.)  Since I know the I350 devices are capable of virtual
> functions, am I correct in assuming it's something similar to the situation
> described at https://bugzilla.redhat.com/show_bug.cgi?id=652210 and there is
> a problem with my BIOS?  Based on comment 15 there, the fact that all
> the DevCtl2 lines show "ARIFwd-" seems interesting.
>
>
> Among other things, I've enabled the following in the kernel config:
>
> CONFIG_DMAR_TABLE=y
> CONFIG_INTEL_IOMMU=y
> CONFIG_INTEL_IOMMU_DEFAULT_ON=y
> CONFIG_PCI_MSI=y
> CONFIG_PCI_STUB=y
> CONFIG_PCI_IOV=y


Just in case anyone else runs into this, it turns out that enabling 
CONFIG_PCI_MMCONFIG allowed the virtual functions to be detected and 
configured.

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
