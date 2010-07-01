Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0GAHQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:16:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32027 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0GAHQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:16:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6029"; a="45995234"
Message-ID: <4C2C40C2.50106@codeaurora.org>
Date: Thu, 01 Jul 2010 00:16:18 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@Oracle.COM>
CC: mel@csn.ul.ie, andi@firstfloor.org, dwalker@codeaurora.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3] mm: iommu: An API to unify IOMMU, CPU and device memory
 management
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <20100630164058.aa6aa3a2.randy.dunlap@oracle.com>
In-Reply-To: <20100630164058.aa6aa3a2.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the corrections. I'm correcting them now. Some responses:

Randy Dunlap wrote:
>> +    struct vcm *vcm_create(size_t start_addr, size_t len);
> 
> Seems odd to use size_t for start_addr.

I used size_t because I wanted to allow the start_addr the same range
as len. Is there a better type to use? I see 'unsigned long' used
throughout the mm code. Perhaps that's better for both the start_addr
and len.


>> +A Reservation is created and destroyed with:
>> +
>> +    struct res *vcm_reserve(struct vcm *vcm, size_t len, uint32_t attr);
> 
> s/uint32_t/u32/ ?

Sure.


>> +    Associate and activate all three to their respective devices:
>> +
>> +        avcm_iommu = vcm_assoc(vcm_iommu, dev_iommu, attr0);
>> +        avcm_onetoone = vcm_assoc(vcm_onetoone, dev_onetoone, attr1);
>> +        avcm_vmm = vcm_assoc(vcm_vmm, dev_cpu, attr2);
> 
> error handling on vcm_assoc() failures?

I'll add the deassociate call to the example.


>> +        res_iommu = vcm_reserve(vcm_iommu, SZ_2MB + SZ_4K, attr);
>> +        res_onetoone = vcm_reserve(vcm_onetoone, SZ_2MB + SZ_4K, attr);
>> +        res_vmm = vcm_reserve(vcm_vmm, SZ_2MB + SZ_4K, attr);
> 
> error handling?

I'll add it here too.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
