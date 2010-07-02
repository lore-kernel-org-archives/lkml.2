Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0GBHdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:33:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37955 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0GBHdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:33:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46268310"
Message-ID: <4C2D965F.5000206@codeaurora.org>
Date: Fri, 02 Jul 2010 00:33:51 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org>  <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org>  <20100701101746.3810cc3b.randy.dunlap@oracle.com>  <20100701180241.GA3594@basil.fritz.box>  <1278012503.7738.17.camel@c-dwalke-linux.q <1278021944.7738.43.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1278021944.7738.43.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2010-07-01 at 15:00 -0700, Zach Pfeffer wrote:
> 
> 
>> Additionally, the current IOMMU interface does not allow users to
>> associate one page table with multiple IOMMUs unless the user explicitly
>> wrote a muxed device underneith the IOMMU interface. This also could be
>> done, but would have to be done for every such use case. Since the
>> particular topology is run-time configurable all of these use-cases and
>> more can be expressed without pushing the topology into the low-level
>> IOMMU driver.
>>
>> The VCMM takes the long view. Its designed for a future in which the
>> number of IOMMUs will go up and the ways in which these IOMMUs are
>> composed will vary from system to system, and may vary at
>> runtime. Already, there are ~20 different IOMMU map implementations in
>> the kernel. Had the Linux kernel had the VCMM, many of those
>> implementations could have leveraged the mapping and topology management
>> of a VCMM, while focusing on a few key hardware specific functions (map
>> this physical address, program the page table base register).
> 
> So if we include this code which "map implementations" could you
> collapse into this implementations ? Generally , what currently existing
> code can VCMM help to eliminate?

In theory, it can eliminate all code the interoperates between IOMMU,
CPU and non-IOMMU based devices and all the mapping code, alignment,
mapping attribute and special block size support that's been
implemented.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
